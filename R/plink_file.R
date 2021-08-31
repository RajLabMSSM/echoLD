#' Find correct plink file
#'
#' @param plink User-provided path to plink executable.
#' @inheritParams echoconda::find_package
#' @family LD
#' @keywords internal
plink_file <- function(plink = NULL,
                       conda_env = "echoR") {
    if (!is.null(plink)) {
        return(plink)
    } else if (!is.null(conda_env)) {
        plink <- echoconda::find_package("plink", conda_env = conda_env)
        return(plink)
    } else {
        return("plink")
    }
}
