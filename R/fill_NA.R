#' Fill NAs in an LD matrix
#'
#' Trickier than it looks.
#'
#' \code{
#' BST1_LD_matrix <- echodata::BST1_LD_matrix
#' LD_matrix <- echodata:::fill_NA(BST1_LD_matrix)
#' }
#'
#' @param LD_matrix LD matrix
#' @param fillNA Fill all NAs in the \code{LD_matrix} with \code{fillNA} value.
#' @param verbose Print messages.
#'
#' @keywords internal
fill_NA <- function(LD_matrix,
                    fillNA = 0,
                    verbose = FALSE) {
    messager("+ echoLD:: Removing unnamed rows/cols", v = verbose)
    # First, filter any rows/cols without names
    LD_matrix <- data.frame(as.matrix(LD_matrix))
    LD_matrix <- LD_matrix[
        rownames(LD_matrix) != ".",
        colnames(LD_matrix) != "."
    ]
    LD_matrix_orig <- LD_matrix

    if (!is.null(fillNA)) {
        messager("+ echoLD:: Replacing NAs with", fillNA, v = verbose)
        if (sum(is.na(LD_matrix)) > 0) {
            LD_matrix[is.na(LD_matrix)] <- 0
        }
    }
    # Check for duplicate SNPs
    LD_matrix <- LD_matrix[
        row.names(LD_matrix)[!duplicated(row.names(LD_matrix))],
        colnames(LD_matrix)[!duplicated(colnames(LD_matrix))]
    ]
    return(LD_matrix)
}
