report_time <- function(start, v=TRUE){
    messager(
        utils::capture.output(round(difftime(Sys.time(), start), 1)),
             v = v)
}