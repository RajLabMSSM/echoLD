#' Read LD list
#' 
#' Import existing LD results.
#' @param RDS_path Path to saved LD matrix.
#' @param query_dat Query data.frame.
#' @param verbose Print messages.
#' @inheritParams get_LD 
#' 
#' @returns LD list with 3 elements.
#' 
#' @keywords internal
read_LD_list <- function(LD_path,
                         query_dat,
                         as_sparse=TRUE,
                         verbose=TRUE){
    messager("Previously computed LD_matrix detected.",
             "Importing:", LD_path,
             v = verbose
    )
    LD_matrix <- readSparse(
        LD_path = LD_path,
        as_sparse = as_sparse,
        verbose = verbose
    )
    LD_list <- list(
        LD = LD_matrix,
        DT = query_dat,
        path = LD_path
    )
    return(LD_list)
}
