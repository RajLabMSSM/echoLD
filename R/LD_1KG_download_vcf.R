#' Download VCF subset from 1000 Genomes
#'
#'
#' Query the 1000 Genomes Project for a subset of their individual-level VCF
#' files.
#' @inheritParams get_LD
#' @inheritParams echotabix::query_vcf
#' @source
#' \code{
#' query_dat <- echodata::BST1
#' locus_dir <- file.path(tempdir(), echodata::locus_dir)
#' query_granges <- echotabix::construct_query(query_dat=query_dat)
#'
#' vcf_subset.popDat <- echoLD:::get_LD_1KG_download_vcf(
#'     query_granges = query_granges,
#'     LD_reference = "1KGphase1",
#'     locus_dir = locus_dir)
#' } 
#' @family LD
#' @keywords internal
#' @importFrom echotabix query_vcf
get_LD_1KG_download_vcf <- function(query_granges,
                                LD_reference = "1KGphase1",
                                superpopulation = NULL,
                                samples = NULL,
                                local_storage = NULL,
                                locus_dir = tempdir(),
                                save_path  = echotabix::construct_vcf_path(
                                    locus_dir = locus_dir, 
                                    subdir = "LD",
                                    target_path = LD_reference,  
                                    query_granges = query_granges
                                    ),
                                query_save = TRUE,
                                force_new = FALSE,
                                verbose = TRUE) {
    
    LD_reference <- tolower(LD_reference)[1]
    # throw error if anything but phase 1 or phase 3 are specified
    if (!LD_reference %in% c("1kgphase1", "1kgphase3")) {
        stop("LD_reference must be one of '1KGphase1' or '1KGphase3'.")
    } 
    all_chroms <- unique(as.character(GenomicRanges::seqnames(query_granges)))
    target_path <- get_1KG_url(
        LD_reference = LD_reference,
        chrom = gsub("chr", "", all_chroms[1]),
        local_storage = local_storage
    )
    #### Select samples ####
    samples <- select_vcf_samples(
        samples = samples,
        superpopulation = superpopulation,
        LD_reference = LD_reference,
        verbose = verbose
    )
    #### Query ####  
    vcf <- echotabix::query_vcf( 
        target_path = target_path, 
        ### 1KG is all aligned to GRCh37
        target_genome = "GRCh37", 
        query_granges = query_granges,
        samples = samples,
        query_save = query_save,
        save_path = save_path,
        force_new = force_new,
        overlapping_only = TRUE,
        verbose = verbose
    )
    #### Return ####
    return(vcf)
}
