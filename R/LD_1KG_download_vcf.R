#' Download VCF subset from 1000 Genomes
#'
#'
#' Query the 1000 Genomes Project for a subset of their individual-level VCF
#' files.
#'
#' \code{
#' data("BST1")
#' vcf_subset.popDat <- LD_1KG_download_vcf(
#'     dat = BST1,
#'     LD_reference = "1KGphase1",
#'     locus_dir = file.path(tempdir(), locus_dir)
#' )
#' }
#' @family LD
#' @keywords internal
#'
#' @inheritParams load_or_create
#' @inheritParams query_vcf
LD_1KG_download_vcf <- function(dat,
                                LD_reference = "1KGphase1",
                                superpopulation = NULL,
                                samples = NULL,
                                local_storage = NULL,
                                locus_dir,
                                force_new_vcf = FALSE,
                                verbose = TRUE) {
    LD_reference <- tolower(LD_reference)[1]
    # throw error if anything but phase 1 or phase 3 are specified
    if (!LD_reference %in% c("1kgphase1", "1kgphase3")) {
        stop("LD_reference must be one of '1KGphase1' or '1KGphase3'.")
    }
    phase <- gsub("1KG", "", LD_reference)
    vcf_url <- get_1KG_url(
        LD_reference = LD_reference,
        chrom = gsub("chr", "", dat$CHR[1]),
        local_storage = local_storage
    )
    #### Query ####
    vcf <- query_vcf(
        dat = dat,
        vcf_url = vcf_url,
        locus_dir = locus_dir,
        LD_reference = LD_reference,
        LD_genome_build = "GRCh37",
        superpopulation = superpopulation,
        samples = samples,
        force_new_vcf = force_new_vcf,
        verbose = verbose
    )
    #### Return ####
    return(vcf)
}
