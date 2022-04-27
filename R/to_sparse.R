to_sparse <- function(X,
                      verbose = TRUE) {
    messager("Converting obj to sparseMatrix.", v = verbose)
    if (!is_sparse_matrix(X)) {
        if (methods::is(X, "data.frame") |
            methods::is(X, "data.table") ) {
            X <- methods::as(as.matrix(X), "sparseMatrix")
        } else if(methods::is(X, "matrix") |
                  methods::is(X, "Matrix")){
            X <- methods::as(X, "sparseMatrix")
        } else {
            stp <- paste("X must be a data.frame or matrix",
                         "to convert to sparse matrix.")
            stop(stp)
        }
    }
    return(X)
}
