#' Fill NAs in an LD matrix
#'
#' Trickier than it looks.
#' @examples
#' \dontrun{
#' data("LD_matrix")
#' LD_matrix <- fill_NA(LD_matrix)
#' }
fill_NA <- function(LD_matrix,
                    fillNA = 0,
                    verbose = FALSE) {
    messager("+ LD:: Removing unnamed rows/cols", v = verbose)
    # First, filter any rows/cols without names
    LD_matrix <- data.frame(LD_matrix)
    LD_matrix <- LD_matrix[rownames(LD_matrix) != ".", colnames(LD_matrix) != "."]
    LD_matrix_orig <- LD_matrix

    if (!is.null(fillNA)) {
        messager("+ LD:: Replacing NAs with", fillNA, v = verbose)
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
