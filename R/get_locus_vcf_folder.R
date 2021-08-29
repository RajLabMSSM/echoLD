#' Get VCF storage folder
#' @family LD
#' @keywords internal
#' @examples
#' data("locus_dir")
#' vcf_folder <- get_locus_vcf_folder(locus_dir = locus_dir)
get_locus_vcf_folder <- function(locus_dir = NULL) {
    vcf_folder <- file.path(locus_dir, "LD")
    out <- dir.create(vcf_folder, showWarnings = FALSE, recursive = TRUE)
    return(vcf_folder)
}
