#' Compute LD from VCF file
#'
#' Imports a subset of a local or remote VCF file that matches
#'  your locus coordinates. Then uses \link[snpStats]{ld}
#'   to calculate LD on the fly. 
#' @param stats LD stats to r
#' @param fillNA When pairwise LD between two SNPs is \code{NA},
#' replace with 0.
#' @inheritParams get_LD
#' @inheritParams get_MAF_UKB
#' @inheritParams echotabix::query_vcf
#' @inheritParams echotabix::query
#' @inheritParams snpStats::ld
#'
#' @family LD
#' @export
#' @importFrom echotabix query_vcf
#' @importFrom VariantAnnotation genotypeToSnpMatrix
#' @examples  
#' query_dat <-  echodata::BST1[seq(1, 50), ]
#' locus_dir <- echodata::locus_dir
#' locus_dir <- file.path(tempdir(), locus_dir) 
#' LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
#'     package = "echodata"
#' )
#' LD_list <- get_LD_vcf(
#'     locus_dir = locus_dir,
#'     query_dat = query_dat,
#'     LD_reference = LD_reference) 
get_LD_vcf <- function(locus_dir = tempdir(),
                       query_dat,
                       LD_reference,
                       query_genome = "hg19",
                       target_genome = "hg19",
                       superpopulation = NULL,
                       samples = NULL, 
                       overlapping_only = TRUE,
                       leadSNP_LD_block = FALSE,
                       force_new = FALSE,
                       force_new_maf = FALSE,
                       fillNA = 0,
                       stats = "R",
                       as_sparse = TRUE,
                       subset_common = TRUE,
                       remove_tmps = TRUE,
                       nThread = 1,
                       conda_env = "echoR_mini",
                       verbose = TRUE) {
    
    messager("Using custom VCF as LD reference panel.", v = verbose) 
    target_path <- LD_reference  
    #### Query ####
    vcf <- echotabix::query(
        query_granges = query_dat,
        target_path = target_path, 
        query_genome = query_genome,
        target_genome = target_genome,
        target_format = "vcf",
        samples = samples,
        as_datatable = FALSE,
        query_force_new = force_new,
        overlapping_only = overlapping_only,
        nThread = nThread,
        conda_env = conda_env,
        verbose = verbose
    )
    #### Convert to snpStats object ####
    ss <- VariantAnnotation::genotypeToSnpMatrix(
        x = vcf,
        select.snps = query_dat$SNP
    )
    #### Get MAF (if needed) ####
    query_dat <- snpstats_get_MAF(
        query_dat = query_dat,
        ss = ss,
        force_new_maf = force_new_maf,
        verbose = verbose
    )
    #### Filter out SNPs not in the same LD block as the lead SNP ####
    if (isTRUE(leadSNP_LD_block)) {
        dat_LD <- get_leadsnp_block(
            query_dat = query_dat,
            ss = ss,
            verbose = verbose
        )
        query_dat <- dat_LD$query_dat
        LD_r2 <- dat_LD$LD_r2
    }
    #### Get LD ####
    if (tolower(stats) %in% c("r.squared", "r2")) {
        # pre-computed during LD block clustering
        LD_matrix <- LD_r2
    } else {
        LD_matrix <- compute_LD(
            ss = ss,
            select_snps = query_dat$SNP,
            stats = stats,
            verbose = verbose
        )
    }
    #### Save LD matrix ####
    LD_list <- save_LD_matrix(
        LD_matrix = LD_matrix,
        dat = query_dat,
        locus_dir = locus_dir,
        fillNA = fillNA,
        LD_reference = LD_reference,
        as_sparse = as_sparse,
        verbose = verbose,
        subset_common = subset_common
    )
    #### Remove tmp files ####
    if(isTRUE(remove_tmps)){
        tbis <- list.files(pattern = ".tbi")
        if(length(tbis)>0){
            messager("Removing",length(tbis),"temp files.",v=verbose)
            out <- file.remove(tbis)
        }
    }
    return(LD_list)
}
