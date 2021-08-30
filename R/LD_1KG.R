#' Compute LD from 1000 Genomes
#'
#' Downloads a subset vcf of the 1KG database that matches
#'  your locus coordinates. Then uses \link[snpStats]{ld}
#'   to calculate LD on the fly.
#'
#' This approach is taken, because other API query tools have 
#' limitations with the window size being queried.
#' This approach does not have this limitations, 
#' allowing you to fine-map loci more completely.
#'
#' @param fillNA When pairwise LD (r) between two SNPs is \code{NA}, 
#' replace with 0.
#' @inheritParams load_or_create
#' @inheritParams echoconda::find_package
#' 
#' @family LD
#' @keywords internal
LD_1KG <- function(locus_dir,
                   dat,
                   LD_reference = "1KGphase1",
                   superpopulation = "EUR",
                   vcf_folder = NULL,
                   remote_LD = TRUE,
                   # min_r2=F, 
                   LD_block_size = NULL,
                   # min_Dprime=F,
                   # remove_correlates = FALSE,
                   remove_tmps = TRUE,
                   fillNA = 0,
                   download_method = "axel",
                   as_sparse = TRUE,
                   nThread = 1,
                   conda_env = "echoR",
                   verbose = TRUE) {
    # data("BST1"); data("locus_dir"); dat=BST1; LD_reference="1KGphase1"; 
    # vcf_folder=NULL; superpopulation="EUR";
    # min_r2=F; LD_block=F; LD_block_size=.7; min_Dprime=F;  
    # remove_correlates=F; remote_LD=T; verbose=T; nThread=4; conda_env="echoR";
    messager("LD:: Using 1000Genomes as LD reference panel.", v = verbose)
    locus <- basename(locus_dir)
    vcf_info <- LD_1KG_download_vcf(
        dat = dat,
        locus_dir = locus_dir,
        LD_reference = LD_reference,
        vcf_folder = vcf_folder,
        locus = locus,
        remote_LD = remote_LD,
        remove_tmps = remove_tmps,
        download_method = download_method,
        nThread = nThread,
        conda_env = conda_env,
        verbose = verbose
    )
    vcf_subset <- vcf_info$vcf_subset
    popDat <- vcf_info$popDat
    vcf.gz.path <- filter_vcf(
        vcf_subset = vcf_subset,
        popDat = popDat,
        superpopulation = superpopulation,
        remove_tmp = TRUE,
        verbose = verbose
    )
    bed_bim_fam <- vcf_to_bed(
        vcf.gz.subset = vcf.gz.path,
        locus_dir = locus_dir,
        verbose = verbose
    )
    # Calculate LD
    LD_matrix <- snpstats_get_LD(
        bed_bim_fam = bed_bim_fam,
        select_snps = unique(dat$SNP),
        stats = c("R"),
        symmetric = TRUE,
        depth = "max",
        verbose = verbose
    )
    # Get MAF (if needed)
    dat <- snpstats_get_MAF(
        dat = dat,
        bed_bim_fam = bed_bim_fam,
        force_new_MAF = TRUE,
        nThread = nThread,
        verbose = verbose
    )
    # Get lead SNP rsid
    leadSNP <- subset(dat, leadSNP == T)$SNP
    # Filter out SNPs not in the same LD block as the lead SNP
    if (!is.null(LD_block_size)) {
        block_snps <- leadSNP_block(
            leadSNP = leadSNP,
            bed_bim_fam = bed_bim_fam,
            LD_block_size = LD_block_size
        )
        LD_matrix <- LD_matrix[
            row.names(LD_matrix) %in% block_snps,
            colnames(LD_matrix) %in% block_snps
        ]
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
        subset_common = TRUE,
        as_sparse = as_sparse,
        fillNA = fillNA,
        LD_reference = LD_reference,
        verbose = verbose
    )
    return(LD_list)
}
