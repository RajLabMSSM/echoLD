#' printer
#'
#' Concatenate and print any number of items.
#'
#' @family general
#' @keywords internal
printer <- function(..., v = T) {
    if (v) {
        print(paste(...))
    }
}
