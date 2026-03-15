test_that("read_LD_list returns correct structure", {
    # Save a small LD matrix to disk
    snps <- paste0("rs", seq_len(5))
    ld_mat <- matrix(0.5, nrow = 5, ncol = 5,
                     dimnames = list(snps, snps))
    diag(ld_mat) <- 1

    path <- tempfile(fileext = ".rds")
    on.exit(unlink(path), add = TRUE)
    saveRDS(ld_mat, path)

    query_dat <- data.table::data.table(
        SNP = snps,
        CHR = 1,
        POS = seq(100, 500, by = 100)
    )

    result <- echoLD:::read_LD_list(
        LD_path = path,
        query_dat = query_dat,
        as_sparse = TRUE,
        verbose = FALSE
    )

    testthat::expect_type(result, "list")
    testthat::expect_equal(names(result), c("LD", "DT", "path"))
    testthat::expect_equal(result$path, path)
    testthat::expect_true(echoLD:::is_sparse_matrix(result$LD))
    testthat::expect_equal(result$DT, query_dat)
})

test_that("read_LD_list returns dense when as_sparse=FALSE", {
    snps <- paste0("rs", seq_len(3))
    ld_mat <- diag(3)
    dimnames(ld_mat) <- list(snps, snps)

    path <- tempfile(fileext = ".rds")
    on.exit(unlink(path), add = TRUE)
    saveRDS(ld_mat, path)

    query_dat <- data.table::data.table(
        SNP = snps, CHR = 1, POS = c(100, 200, 300)
    )

    result <- echoLD:::read_LD_list(
        LD_path = path,
        query_dat = query_dat,
        as_sparse = FALSE,
        verbose = FALSE
    )

    testthat::expect_false(echoLD:::is_sparse_matrix(result$LD))
})
