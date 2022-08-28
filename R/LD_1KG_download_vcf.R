#' Download VCF subset from 1000 Genomes
#'
#'
#' Query the 1000 Genomes Project for a subset of their individual-level VCF
#' files.
#' @param save_path Path to save LD subset to.
#' @inheritParams get_LD
#' @inheritParams echotabix::query 
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
#' @importFrom echotabix query liftover 
get_LD_1KG_download_vcf <- function(query_granges,
                                    query_genome = "hg19",
                                    LD_reference = "1KGphase1",
                                    superpopulation = NULL,
                                    samples = character(0),
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
                                    conda_env = "echoR_mini",
                                    nThread = 1,
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
    #### Liftover ####
    query_granges <- echotabix::liftover(dat = query_granges, 
                                         query_genome = query_genome, 
                                         target_genome = "hg19",
                                         as_granges = TRUE,
                                         style = "UCSC",
                                         verbose = verbose)
    #### Query ####  
    vcf <- echotabix::query( 
        target_path = target_path, 
        query_genome = query_genome,
        target_format = "vcf",
        ### 1KG is all aligned to GRCh37
        target_genome = "GRCh37", 
        query_granges = query_granges,
        samples = samples,
        query_save = query_save,
        query_save_path = save_path,
        query_force_new = force_new,
        overlapping_only = TRUE,
        as_datatable = FALSE,
        conda_env = conda_env,
        nThread = nThread,
        verbose = verbose
    )
    #### Return ####
    return(vcf)
}
