#' #' Convert vcf file to BED file
#' #'
#' #' Uses plink to convert vcf to BED.
#' #' @param vcf.gz.subset Path to the gzipped locus subset vcf.
#' #' @param locus_dir Locus-specific results directory.
#' #' @family LD
#' #' @keywords internal
#' vcf_to_bed_cli <- function(vcf.gz.subset,
#'                            locus_dir,
#'                            plink_prefix = "plink",
#'                            conda_env = "echoR",
#'                            verbose = TRUE) {
#'     plink <- echoconda::find_packages(packages = "plink",
#'                                       conda_env = conda_env,
#'                                       verbose = verbose)
#'     messager("LD:PLINK:: Converting vcf.gz to .bed/.bim/.fam", v = verbose)
#'     LD_dir <- file.path(locus_dir, "LD")
#'     dir.create(LD_dir, recursive = TRUE, showWarnings = FALSE)
#'     cmd <- paste(
#'         plink,
#'         "--vcf", vcf.gz.subset,
#'         "--out", file.path(LD_dir, plink_prefix)
#'     )
#'     system(cmd)
#' 
#'     return(
#'         list(
#'             bed = file.path(LD_dir, paste0(plink_prefix, ".bed")),
#'             bim = file.path(LD_dir, paste0(plink_prefix, ".bim")),
#'             fam = file.path(LD_dir, paste0(plink_prefix, ".fam"))
#'         )
#'     )
#' }
