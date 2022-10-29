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
#' @param as_sparse Save/return LD matrix as a sparse matrix. 
#' @inheritParams get_LD 
#' @inheritParams echotabix::query
#'
#' @family LD
#' @keywords internal
#' @importFrom VariantAnnotation genotypeToSnpMatrix
get_LD_1KG <- function(locus_dir,
                       query_dat,
                       query_genome = "hg19",
                       LD_reference = "1KGphase1",
                       superpopulation = NULL,
                       samples = character(0),
                       local_storage = NULL,
                       leadSNP_LD_block = FALSE,
                       force_new = FALSE,
                       force_new_maf = FALSE,
                       fillNA = 0,
                       stats = "R",
                       as_sparse = TRUE,
                       remove_tmps = TRUE,
                       conda_env = "echoR_mini",
                       # min_r2=FALSE,
                       # min_Dprime=FALSE,
                       # remove_correlates = FALSE,
                       nThread = 1,
                       verbose = TRUE) {
    
    messager("Using 1000Genomes as LD reference panel.", v = verbose)
    #### Query ####
    query_granges <- echotabix::construct_query(query_dat = query_dat,
                                                verbose = verbose)
    vcf <- get_LD_1KG_download_vcf(
        query_granges = query_granges,
        query_genome = query_genome,
        locus_dir = locus_dir,
        LD_reference = LD_reference,
        superpopulation = superpopulation,
        samples = samples,
        force_new = force_new,
        local_storage = local_storage,
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
    if (leadSNP_LD_block) {
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
        subset_common = TRUE,
        fillNA = fillNA,
        LD_reference = LD_reference,
        as_sparse = as_sparse,
        verbose = verbose
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
