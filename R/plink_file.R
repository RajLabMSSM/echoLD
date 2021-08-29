#' Find correct plink file
#'
#' @family LD
#' @keywords internal
#' @examples
#' plink <- plink_file()
plink_file <- function(plink = "plink",
                       conda_env = NULL) {
    if (!is.null(conda_env)) {
        plink <- echoconda::find_package("plink", conda_env = conda_env)
    }
    if (plink == "plink") {
        base_url <- system.file("tools/plink", package = "echolocatoR")
        os <- get_os()
        if (os == "osx") {
            plink <- file.path(base_url, "plink1.9_mac")
        } else if (os == "linux") {
            plink <- file.path(base_url, "plink1.9_linux")
        } else {
            plink <- file.path(base_url, "plink1.9_windows.exe")
        }
    }
    return(plink)
}
