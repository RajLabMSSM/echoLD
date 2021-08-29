#' Compute LD from user-supplied vcf file
#'
#' @family LD
#' @keywords internal
#' @examples
#' \dontrun{
#' if (!"gaston" %in% row.names(installed.packages())) {
#'     install.packages("gaston")
#' }
#' data("BST1")
#' data("locus_dir")
#' LD_reference <- "~/Desktop/results/Reference/custom_panel_chr4.vcf"
#' LD_matrix <- custom_panel(LD_reference = LD_reference, dat = BST1, locus_dir = locus_dir)
#'
#' locus_dir <- "/sc/arion/projects/pd-omics/brian/Fine_Mapping/Data/QTL/Microglia_all_regions/BIN1"
#' dat <- data.table::fread(file.path(locus_dir, "Multi-finemap/BIN1.Microglia_all_regions.1KGphase3_LD.Multi-finemap.tsv.gz"))
#' LD_reference <- "/sc/hydra/projects/pd-omics/glia_omics/eQTL/post_imputation_filtering/eur/filtered_variants/AllChr.hg38.sort.filt.dbsnp.snpeff.vcf.gz"
#' LD_matrix <- custom_panel(LD_reference = LD_reference, dat = BST1, locus_dir = locus_dir, LD_genome_build = "hg38")
#' }
custom_panel <- function(LD_reference,
                         fullSS_genome_build = "hg19",
                         LD_genome_build = "hg19",
                         dat,
                         locus_dir,
                         force_new_LD = FALSE,
                         min_r2 = FALSE,
                         # min_Dprime=F,
                         remove_correlates = FALSE,
                         fillNA = 0,
                         LD_block = FALSE,
                         LD_block_size = .7,
                         remove_tmps = TRUE,
                         as_sparse = TRUE,
                         nThread = 1,
                         conda_env = "echoR",
                         verbose = TRUE) {
    messager("LD:: Computing LD from local vcf file:", LD_reference)

    if (!toupper(LD_genome_build) %in% c("HG19", "HG37", "GRCH37")) {
        messager("LD:: LD panel in hg38. Handling accordingly.", v = verbose)
        if (!toupper(fullSS_genome_build) %in% c("HG19", "HG37", "GRCH37")) {
            ## If the query was originally in hg38,
            # that means it's already been lifted over to hg19.
            # So you can use the old stored POS.hg38 when the
            dat <- dat %>%
                dplyr::rename(POS.hg19 = POS) %>%
                dplyr::rename(POS = POS.hg38)
        } else {
            ## If the query was originally in hg19,
            # that means no liftover was done.
            # So you need to lift it over now.
            dat <- LIFTOVER(
                dat = dat,
                build.conversion = "hg19.to.hg38",
                return_as_granges = FALSE,
                verbose = verbose
            )
        }
    }
    vcf_file <- index_vcf(
        vcf_file = LD_reference,
        force_new_index = FALSE,
        conda_env = conda_env,
        verbose = verbose
    )
    # Make sure your query's chr format is the same as the vcf's chr format
    has_chr <- determine_chrom_type_vcf(vcf_file = vcf_file)
    dat <- dplyr::mutate(dat,
        CHR = if (has_chr) paste0("chr", gsub("chr", "", CHR)) else gsub("chr", "", CHR)
    )

    vcf_subset <- query_vcf(
        dat = dat,
        locus_dir = locus_dir,
        LD_reference = LD_reference,
        vcf_URL = LD_reference,
        whole_vcf = FALSE,
        remove_original_vcf = FALSE,
        force_new_vcf = force_new_LD,
        query_by_regions = FALSE,
        nThread = nThread,
        conda_env = conda_env,
        verbose = verbose
    )

    bed_bim_fam <- vcf_to_bed(
        vcf.gz.subset = vcf_subset,
        locus_dir = locus_dir,
        plink_prefix = "plink",
        verbose = verbose
    )
    # Calculate LD
    LD_matrix <- snpstats_get_LD(
        LD_folder = file.path(locus_dir, "LD"),
        plink_prefix = "plink",
        select.snps = unique(dat$SNP),
        stats = c("R"),
        symmetric = TRUE,
        depth = "max",
        verbose = verbose
    )
    # Get MAF (if needed)
    dat <- snpstats_get_MAF(
        dat = dat,
        LD_folder = file.path(locus_dir, "LD"),
        plink_prefix = "plink",
        force_new_MAF = FALSE,
        verbose = verbose
    )
    # Filter out SNPs not in the same LD block as the lead SNP
    # Get lead SNP rsid
    leadSNP <- subset(dat, leadSNP == T)$SNP
    if (LD_block) {
        block_snps <- leadSNP_block(
            leadSNP = leadSNP,
            LD_folder = "./plink_tmp",
            LD_block_size = LD_block_size
        )
        LD_matrix <- LD_matrix[row.names(LD_matrix) %in% block_snps, colnames(LD_matrix) %in% block_snps]
        LD_matrix <- LD_matrix[block_snps, block_snps]
    }
    # IMPORTANT! Remove large data.ld file after you're done with it
    if (remove_tmps) {
        suppressWarnings(file.remove(vcf_subset))
    }
    # Save LD matrix
    LD_list <- save_LD_matrix(
        LD_matrix = LD_matrix,
        dat = dat,
        locus_dir = locus_dir,
        fillNA = fillNA,
        LD_reference = gsub(".vcf|.gz", "", LD_reference),
        as_sparse = as_sparse,
        verbose = verbose
    )
    return(LD_list)
}
