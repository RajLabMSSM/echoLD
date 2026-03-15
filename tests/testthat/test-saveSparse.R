test_that("saveSparse saves and returns path", {
    ld_mat <- echodata::BST1_LD_matrix
    path <- tempfile(fileext = ".rds")
    on.exit(unlink(path), add = TRUE)

    result <- echoLD::saveSparse(
        LD_matrix = ld_mat,
        LD_path = path,
        verbose = FALSE
    )

    testthat::expect_equal(result, path)
    testthat::expect_true(file.exists(path))

    # Read back and verify it is sparse
    loaded <- readRDS(path)
    testthat::expect_true(echoLD:::is_sparse_matrix(loaded))
})

test_that("saveSparse converts dense matrix to sparse before saving", {
    mat <- diag(4)
    rownames(mat) <- colnames(mat) <- paste0("rs", seq_len(4))
    path <- tempfile(fileext = ".rds")
    on.exit(unlink(path), add = TRUE)

    result <- echoLD::saveSparse(
        LD_matrix = mat,
        LD_path = path,
        verbose = FALSE
    )

    loaded <- readRDS(path)
    testthat::expect_true(echoLD:::is_sparse_matrix(loaded))
})

test_that("saveSparse uses tempfile when no path given", {
    mat <- diag(3)
    rownames(mat) <- colnames(mat) <- paste0("rs", seq_len(3))

    result <- echoLD::saveSparse(
        LD_matrix = mat,
        verbose = FALSE
    )

    testthat::expect_true(file.exists(result))
    on.exit(unlink(result), add = TRUE)
})
