#' Read LD list
#' 
#' Import existing LD results.
#' @param RDS_path Path to saved LD matrix.
#' @param query_dat Query data.frame.
#' @param verbose Print messages.
#' 
#' @returns LD list with 3 elements.
#' 
#' @keywords internal
read_LD_list <- function(RDS_path,
                         query_dat,
                         verbose=TRUE){
    messager("Previously computed LD_matrix detected.",
             "Importing:", RDS_path,
             v = verbose
    )
    LD_matrix <- readSparse(
        LD_path = RDS_path,
        convert_to_df = FALSE
    )
    LD_list <- list(
        LD = LD_matrix,
        DT = query_dat,
        path = RDS_path
    )
    return(LD_list)
}
