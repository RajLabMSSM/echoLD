test_that("to_sparse converts data.frame to sparse matrix", {
    df <- data.frame(a = c(1, 0, 0), b = c(0, 1, 0), c = c(0, 0, 1))
    result <- echoLD::to_sparse(X = df, verbose = FALSE)

    testthat::expect_true(echoLD:::is_sparse_matrix(result))
    testthat::expect_equal(nrow(result), 3)
    testthat::expect_equal(ncol(result), 3)
})

test_that("to_sparse converts regular matrix to sparse matrix", {
    mat <- diag(5)
    rownames(mat) <- colnames(mat) <- paste0("rs", seq_len(5))
    result <- echoLD::to_sparse(X = mat, verbose = FALSE)

    testthat::expect_true(echoLD:::is_sparse_matrix(result))
    testthat::expect_equal(dim(result), c(5, 5))
})

test_that("to_sparse returns sparse matrix unchanged", {
    sparse_mat <- Matrix::Matrix(diag(3), sparse = TRUE)
    result <- echoLD::to_sparse(X = sparse_mat, verbose = FALSE)

    testthat::expect_true(echoLD:::is_sparse_matrix(result))
    testthat::expect_identical(result, sparse_mat)
})

test_that("to_sparse errors on unsupported types", {
    testthat::expect_error(
        echoLD::to_sparse(X = "not a matrix", verbose = FALSE)
    )
    testthat::expect_error(
        echoLD::to_sparse(X = list(a = 1), verbose = FALSE)
    )
})

test_that("to_sparse converts data.table to sparse matrix", {
    dt <- data.table::data.table(a = c(1, 0), b = c(0, 1))
    result <- echoLD::to_sparse(X = dt, verbose = FALSE)

    testthat::expect_true(echoLD:::is_sparse_matrix(result))
    testthat::expect_equal(dim(result), c(2, 2))
})
