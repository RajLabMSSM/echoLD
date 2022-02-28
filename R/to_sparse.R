to_sparse <- function(X,
                      verbose = TRUE) {
    messager("Converting obj to sparseMatrix.", v = verbose)
    if (!is_sparse_matrix(X)) {
        if (methods::is(X, "data.frame") |
            methods::is(X, "data.table") |
            methods::is(X, "matrix") |
            methods::is(X, "Matrix")) {
            X <- methods::as(as.matrix(X), "sparseMatrix")
        }
    }
    return(X)
}
