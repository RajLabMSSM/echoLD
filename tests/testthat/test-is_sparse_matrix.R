test_that("is_sparse_matrix detects dgCMatrix", {
    mat <- Matrix::Matrix(diag(3), sparse = TRUE)
    testthat::expect_true(echoLD:::is_sparse_matrix(mat))
})

test_that("is_sparse_matrix detects TsparseMatrix", {
    # Create a non-diagonal sparse matrix, then coerce to triplet form
    m <- matrix(c(1, 0.5, 0, 0.5, 1, 0.3, 0, 0.3, 1), nrow = 3)
    sp <- methods::as(m, "dgCMatrix")
    mat <- methods::as(sp, "TsparseMatrix")
    testthat::expect_true(echoLD:::is_sparse_matrix(mat))
})

test_that("is_sparse_matrix returns FALSE for regular matrix", {
    mat <- diag(3)
    testthat::expect_false(echoLD:::is_sparse_matrix(mat))
})

test_that("is_sparse_matrix returns FALSE for data.frame", {
    df <- data.frame(a = 1:3, b = 4:6)
    testthat::expect_false(echoLD:::is_sparse_matrix(df))
})

test_that("is_sparse_matrix returns FALSE for numeric vector", {
    testthat::expect_false(echoLD:::is_sparse_matrix(c(1, 2, 3)))
})
