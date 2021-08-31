#' Report time at end of function
#'
#' @keywords internal
#' @importFrom utils capture.output
report_time <- function(start, v = TRUE) {
    messager(
        utils::capture.output(round(difftime(Sys.time(), start), 1)),
        v = v
    )
}
