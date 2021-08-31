#' Query VCF file
#'
#'
#' Query a (remote) Variant Call Format (VCF) file.
#'
#' @param dat SNP-levle data table.
#' @param vcf_url URL or path to VCF.
#' @param locus_dir Directory to store LD in.
#' @param LD_genome_build Genome build of the VCF file.
#' @param superpopulation Ethnic subset of the population to use
#' (only applicable for "1KGphase1" and "1KGphase3").
#' @param samples Sample names to subset the VCF by before computing LD.
#' @param force_new_vcf Force the creation of a new LD file even if one exists.
#' @param verbose Print messages.
#' @inheritParams load_or_create
#'
#' @return a \link[VariantAnnotation]{VCF} object.
#' 
#' @family LD
#' @keywords export
#' @importFrom echoconda find_package
#' @importFrom downloadR downloader
#' @importFrom data.table fwrite
#' @importFrom VariantAnnotation readVcf
query_vcf <- function(dat,
                      vcf_url,
                      locus_dir,
                      LD_reference = "1KGphase3",
                      LD_genome_build = "GRCh37",
                      superpopulation = NULL,
                      samples = NULL,
                      force_new_vcf = FALSE,
                      verbose = TRUE) {
    vcf_subset <- construct_subset_vcf_name(
        dat = dat,
        locus_dir = locus_dir,
        LD_reference = LD_reference
    )
    # CHECK FOR EMPTY VCF FILES!
    ## These can be created if you stop the query early, or if the url fails.
    remove_empty_vcf(
        f = vcf_subset,
        verbose = verbose
    )
    #### Import existing file or create new one ####
    if ((!file.exists(vcf_subset)) | force_new_vcf) {
        samples <- select_vcf_samples(
            samples = samples,
            superpopulation = superpopulation,
            LD_reference = LD_reference,
            verbose = verbose
        )
        vcf <- query_vcf_variantannotation(
            vcf_url = vcf_url,
            dat = dat,
            samples = samples,
            genome = LD_genome_build,
            save_path = vcf_subset
        )
    } else {
        messager("+ Identified existing VCF subset file. Importing...",
            vcf_subset,
            v = verbose
        )
        vcf <- VariantAnnotation::readVcf(vcf_subset)
    }
    messager("Returning VCF with", formatC(nrow(vcf), big.mark = ","), "SNPs",
        "across", formatC(ncol(vcf), big.mark = ","), "samples.",
        v = verbose
    )
    return(vcf)
}
