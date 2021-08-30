#' Construct the path to vcf subset
#'
#'
#'\code{
#' data("locus_dir")
#' data("BST1")
#' vcf_subset <- construct_subset_vcf_name(
#'     dat = BST1,
#'     locus_dir = locus_dir,
#'     LD_reference = "1KGlocal"
#' )
#'}
#' @family LD
#' @keywords internal
construct_subset_vcf_name <- function(dat,
                                      LD_reference = NULL,
                                      locus_dir,
                                      whole_vcf = FALSE) {
    vcf_folder <- get_locus_vcf_folder(locus_dir = locus_dir)
    # Don't use the chr prefix:
    # https://www.internationalgenome.org/faq/how-do-i-get-sub-section-vcf-file/
    dat$CHR <- gsub("chr", "", dat$CHR)
    chrom <- unique(dat$CHR)
    vcf_subset <- file.path(
        vcf_folder,
        if (whole_vcf) {
            paste(basename(LD_reference), paste0("chr", chrom), sep = ".")
        } else {
            paste(basename(locus_dir), basename(LD_reference), sep = ".")
        }
    )
    dir.create(path = dirname(vcf_subset), recursive = T, showWarnings = F)
    if (!(endsWith(vcf_subset, ".vcf.gz") |
        endsWith(vcf_subset, ".vcf"))) {
        vcf_subset <- paste0(vcf_subset, ".vcf")
    }
    return(vcf_subset)
}
