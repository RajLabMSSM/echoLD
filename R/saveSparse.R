#' Save LD matrix as a sparse matrix
#'
#' Converting LD matrices to sparse format reduces file size by half.
#' @param LD_matrix LD matrix to save.
#' @param LD_path Path to save LD matrix to.
#' @param verbose Print messages.
#' @family LD
#' @export 
#' @examples 
#' echodata::BST1_LD_matrix
#' LD_path <- saveSparse(LD_matrix = LD_matrix)
saveSparse <- function(LD_matrix,
                       LD_path=tempfile(fileext = ".rds"),
                       verbose = TRUE) {
    # https://cmdlinetips.com/2019/05/introduction-to-sparse-matrices-in-r/
    # LD_sparse <- Matrix::Matrix(as.matrix(LD_matrix), sparse = TRUE)
    LD_sparse <- to_sparse(X = LD_matrix, 
                           verbose = verbose)
    # messager("Dense size:")
    # print(object.size(LD_matrix),units="auto")
    # messager("Sparse size:")
    # print(object.size(LD_sparse),units="auto") 
    messager("Saving sparse LD matrix ==>", LD_path, v = verbose)
    saveRDS(LD_sparse, LD_path)
    return(LD_path)
}
