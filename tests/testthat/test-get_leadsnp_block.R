test_that("get_leadsnp_block filters to lead SNP block", {
    testthat::skip_if_not_installed("adjclust")

    ld_mat <- echodata::BST1_LD_matrix
    ld_mat_r2 <- ld_mat^2
    sparse_mat <- echoLD::to_sparse(X = ld_mat_r2, verbose = FALSE)

    query_dat <- data.table::data.table(
        SNP = rownames(ld_mat),
        CHR = 4,
        POS = seq_len(nrow(ld_mat)) * 1000,
        P = runif(nrow(ld_mat)),
        leadSNP = c(TRUE, rep(FALSE, nrow(ld_mat) - 1))
    )

    result <- echoLD:::get_leadsnp_block(
        query_dat = query_dat,
        ss = sparse_mat,
        pct = 0.15,
        verbose = FALSE
    )

    testthat::expect_type(result, "list")
    testthat::expect_true("query_dat" %in% names(result))
    testthat::expect_true("LD_r2" %in% names(result))
    # Should have fewer or equal SNPs than the original
    testthat::expect_lte(nrow(result$query_dat), nrow(query_dat))
    # Lead SNP must be in the result
    testthat::expect_true(any(result$query_dat$leadSNP))
})

test_that("get_leadsnp_block returns all SNPs when no leadSNP column", {
    testthat::skip_if_not_installed("adjclust")

    ld_mat <- echodata::BST1_LD_matrix
    ld_mat_r2 <- ld_mat^2
    sparse_mat <- echoLD::to_sparse(X = ld_mat_r2, verbose = FALSE)

    query_dat <- data.table::data.table(
        SNP = rownames(ld_mat),
        CHR = 4,
        POS = seq_len(nrow(ld_mat)) * 1000,
        P = runif(nrow(ld_mat))
    )
    # No leadSNP column

    result <- echoLD:::get_leadsnp_block(
        query_dat = query_dat,
        ss = sparse_mat,
        pct = 0.15,
        verbose = FALSE
    )

    testthat::expect_true("LDblock" %in% colnames(result$query_dat))
})
