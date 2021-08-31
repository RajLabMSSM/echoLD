#' #' Filter a vcf by min/max coordinates
#' #'
#' #' Uses \emph{bcftools} to filter a vcf by min/max genomic coordinates
#' #' (in basepairs).
#' #' @param vcf_subset Path to the locus subset vcf.
#' #' @param superpopulation Superpopulation to subset.
#' #' @family LD
#' #' @keywords internal
#' filter_vcf_cli <- function(vcf_subset,
#'                            superpopulation,
#'                            LD_reference,
#'                            remove_tmp = TRUE,
#'                            conda_env = "echoR",
#'                            verbose = TRUE) {
#'     # Avoid confusing checks
#'     leadSNP <- superpop <- NULL
#' 
#'     bgzip <- echoconda::find_package("bgzip", conda_env = conda_env)
#'     tabix <- echoconda::find_package("tabix", conda_env = conda_env)
#'     bcftools <- echoconda::find_package("bcftools", conda_env = conda_env)
#' 
#'     vcf.gz <- paste0(vcf_subset, ".gz")
#'     vcf.gz.subset <- gsub("_subset", "_samples_subset", vcf.gz)
#'     # Compress vcf
#'     if (!file.exists(vcf.gz)) {
#'         messager("LD:BCFTOOLS:: Compressing vcf file...", v = verbose)
#'         system(paste(bgzip, "-f", vcf_subset))
#'     }
#'     # Re-index vcf
#'     messager("LD:TABIX:: Re-indexing vcf.gz...", v = verbose)
#'     system(paste(tabix, "-f -p vcf", vcf.gz))
#'     # Subset samples
#'     selectedInds <- select_vcf_samples(
#'         superpopulation = superpopulation,
#'         LD_reference = LD_reference,
#'         verbose = verbose
#'     )
#'     messager("LD:BCFTOOLS:: Subsetting vcf", v = verbose)
#'     cmd <- paste(
#'         bcftools, "view -s", paste(selectedInds, collapse = ","),
#'         vcf.gz, "|", bgzip, "> tmp && mv tmp", vcf.gz.subset
#'     )
#'     system(cmd)
#'     # Remove old vcf
#'     if (remove_tmp) {
#'         out <- suppressWarnings(file.remove(vcf_subset))
#'     }
#'     return(vcf.gz.subset)
#' }
