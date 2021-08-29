#' printer
#'
#' Concatenate and print any number of items.
#'
#' @family general
#' @examples
#' n.snps <- 50
#' printer("echolocatoR::", "Processing", n.snps, "SNPs...")
#' @keywords internal
#' @noRd
printer <- function(..., v = T) {
    if (v) {
        print(paste(...))
    }
}
