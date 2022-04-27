#' #' Index vcf file if it hasn't been already
#' #'
#' #' @family LD
#' #' @keywords internal
#' index_vcf_cli <- function(vcf_file,
#'                           force_new_index = FALSE,
#'                           conda_env = "echoR_mini",
#'                           verbose = TRUE) {
#'     if (!endsWith(vcf_file, ".gz")) {
#'         messager("+ LD:: Compressing vcf with bgzip", v = verbose)
#'         bgzip <- echoconda::find_package(
#'             package = "bgzip",
#'             conda_env = conda_env,
#'             verbose = verbose
#'         )
#'         cmd1 <- paste(
#'             bgzip,
#'             vcf_file
#'         )
#'         messager("++ LD::", cmd1, v = verbose)
#'         system(cmd1)
#'         vcf_file <- paste0(vcf_file, ".gz")
#'     } else {
#'         messager("+ LD::", vcf_file, "already compressed", v = verbose)
#'     }
#' 
#'     if (!file.exists(paste0(vcf_file, ".tbi")) | force_new_index) {
#'         messager("+ LD:: Indexing", vcf_file, v = verbose)
#'         tabix <- echoconda::find_package(
#'             package = "tabix",
#'             conda_env = conda_env,
#'             verbose = verbose
#'         )
#'         cmd <- paste(
#'             tabix,
#'             "-fp vcf",
#'             vcf_file
#'         )
#'         messager("++ LD::", cmd, v = verbose)
#'         system(cmd)
#'     } else {
#'         messager("+ LD::", vcf_file, "already indexed.", v = verbose)
#'     }
#'     return(vcf_file)
#' }
