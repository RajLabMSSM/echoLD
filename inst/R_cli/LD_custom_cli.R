#' #' Compute LD from user-supplied VCF file
#' #'
#' #'
#' #' @inheritParams LD_blocks_cli
#' #' @inheritParams echoconda::find_package
#' #'
#' #' @family LD
#' #' @keywords internal
#' #' @examples
#' #' \dontrun{
#' #' data("BST1")
#' #' data("locus_dir")
#' #' LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
#' #'     package = "echoLD"
#' #' )
#' #' LD_matrix <- LD_custom_cli(
#' #'     LD_reference = LD_reference,
#' #'    query_dat= BST1,
#' #'     locus_dir = locus_dir
#' #' )
#' #' }
#' #' @importFrom dplyr %>% rename mutate
#' LD_custom_cli <- function(LD_reference,
#'                           superpopulation = NULL,
#'                           fullSS_genome_build = "hg19",
#'                           target_genome = "hg19",
#'                           query_dat
#'                           locus_dir,
#'                           force_new_LD = FALSE,
#'                           min_r2 = FALSE,
#'                           # min_Dprime=F,
#'                           remove_correlates = FALSE,
#'                           fillNA = 0,
#'                           LD_block_size = NULL,
#'                           remove_tmps = TRUE,
#'                           as_sparse = TRUE,
#'                           nThread = 1,
#'                           conda_env = "echoR_mini",
#'                           verbose = TRUE) {
#'     # Avoid confusing checks
#'     POS <- POS.hg38 <- CHR <- NULL
#' 
#'     messager("Computing LD from local vcf file:", LD_reference)
#' 
#'     if (!toupper(target_genome) %in% c("HG19", "HG37", "GRCH37")) {
#'         messager("LD panel in hg38. Handling accordingly.", v = verbose)
#'         if (!toupper(fullSS_genome_build) %in% c("HG19", "HG37", "GRCH37")) {
#'             ## If the query was originally in hg38,
#'             # that means it's already been lifted over to hg19.
#'             # So you can use the old stored POS.hg38 when the
#'            query_dat<-query_dat%>%
#'                 dplyr::rename(POS.hg19 = POS) %>%
#'                 dplyr::rename(POS = POS.hg38)
#'         } else {
#'             ## If the query was originally in hg19,
#'             # that means no liftover was done.
#'             # So you need to lift it over now.
#'            query_dat<- liftover(
#'                query_dat= query_dat
#'                 build_conversion = "hg19ToHg38",
#'                 as_granges = FALSE,
#'                 verbose = verbose
#'             )
#'         }
#'     }
#'     vcf_file <- index_vcf_cli(
#'         vcf_file = LD_reference,
#'         force_new_index = FALSE,
#'         conda_env = conda_env,
#'         verbose = verbose
#'     )
#'     # Make sure your query's chr format is the same as the vcf's chr format
#'     has_chr <- determine_chrom_type_vcf(vcf_file = vcf_file)
#'    query_dat<- dplyr::mutate(query_dat
#'         CHR = if (has_chr) {
#'             paste0("chr", gsub("chr", "", CHR))
#'         } else {
#'             gsub("chr", "", CHR)
#'         }
#'     )
#' 
#'     vcf_subset <- query_vcf_cli(
#'        query_dat= query_dat
#'         locus_dir = locus_dir,
#'         LD_reference = LD_reference,
#'         vcf_url = LD_reference,
#'         whole_vcf = FALSE,
#'         remove_original_vcf = FALSE,
#'         force_new = force_new_LD,
#'         query_by_regions = FALSE,
#'         nThread = nThread,
#'         conda_env = conda_env,
#'         verbose = verbose
#'     )
#' 
#'     bed_bim_fam <- vcf_to_bed_cli(
#'         vcf.gz.subset = vcf_subset,
#'         locus_dir = locus_dir,
#'         plink_prefix = "plink",
#'         verbose = verbose
#'     )
#'     #### Convert to snpStats
#'     ss <- plink_to_snpstats(
#'         vcf_subset = vcf_subset,
#'         superpopulation = superpopulation,
#'         select_snps = unique(dat$SNP),
#'         locus_dir = locus_dir,
#'         nThread = nThread,
#'         verbose = verbose
#'     )
#'     #### Compute LD ####
#'     LD_matrix <- compute_LD(
#'         ss = ss,
#'         select_snps = unique(dat$SNP),
#'         stats = c("R"),
#'         symmetric = TRUE,
#'         depth = "max",
#'         verbose = verbose
#'     )
#'     #### Get MAF  ####
#'    query_dat<- snpstats_get_MAF(
#'        query_dat= query_dat
#'         ss = ss,
#'         force_new_MAF = FALSE,
#'         verbose = verbose
#'     )
#'     # Filter out SNPs not in the same LD block as the lead SNP
#'     # Get lead SNP rsid
#'     leadSNP <- subset(query_dat leadSNP)$SNP
#'     if (!is.null(LD_block_size)) {
#'         block_snps <- leadsnp_block_plink(
#'             leadSNP = leadSNP,
#'             bed_bim_fam = bed_bim_fam,
#'             LD_block_size = LD_block_size
#'         )
#'         LD_matrix <- LD_matrix[
#'             row.names(LD_matrix) %in% block_snps,
#'             colnames(LD_matrix) %in% block_snps
#'         ]
#'         LD_matrix <- LD_matrix[block_snps, block_snps]
#'     }
#'     # IMPORTANT! Remove large data.ld file after you're done with it
#'     if (remove_tmps) {
#'         suppressWarnings(file.remove(vcf_subset))
#'     }
#'     # Save LD matrix
#'     LD_list <- save_LD_matrix(
#'         LD_matrix = LD_matrix,
#'         dat= query_dat
#'         locus_dir = locus_dir,
#'         fillNA = fillNA,
#'         LD_reference = gsub(".vcf|.gz", "", LD_reference),
#'         as_sparse = as_sparse,
#'         verbose = verbose
#'     )
#'     return(LD_list)
#' }
