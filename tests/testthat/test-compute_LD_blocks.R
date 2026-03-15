test_that("compute_LD_blocks works with sparse LD matrix", {
    testthat::skip_if_not_installed("adjclust")

    # Use BST1 LD matrix (already available via echodata)
    ld_mat <- echodata::BST1_LD_matrix
    # Ensure r2 (non-negative) for adjclust
    ld_mat_r2 <- ld_mat^2
    sparse_mat <- echoLD::to_sparse(X = ld_mat_r2, verbose = FALSE)

    result <- echoLD:::compute_LD_blocks(
        x = sparse_mat,
        pct = 0.15,
        verbose = FALSE
    )

    testthat::expect_type(result, "list")
    testthat::expect_true("fit" %in% names(result))
    testthat::expect_true("clusters" %in% names(result))
    testthat::expect_true(length(unique(result$clusters)) >= 1)
    testthat::expect_equal(length(result$clusters), nrow(ld_mat))
})

test_that("get_LD_blocks assigns LDblock column", {
    testthat::skip_if_not_installed("adjclust")

    ld_mat <- echodata::BST1_LD_matrix
    # Use r2 for adjclust
    ld_mat_r2 <- ld_mat^2
    sparse_mat <- echoLD::to_sparse(X = ld_mat_r2, verbose = FALSE)

    # Create matching query_dat with SNPs from the LD matrix
    query_dat <- data.table::data.table(
        SNP = rownames(ld_mat),
        CHR = 4,
        POS = seq_len(nrow(ld_mat)) * 1000,
        P = runif(nrow(ld_mat)),
        leadSNP = c(TRUE, rep(FALSE, nrow(ld_mat) - 1))
    )

    result <- echoLD::get_LD_blocks(
        query_dat = query_dat,
        ss = sparse_mat,
        pct = 0.15,
        verbose = FALSE
    )

    testthat::expect_type(result, "list")
    testthat::expect_true("query_dat" %in% names(result))
    testthat::expect_true("LD_r2" %in% names(result))
    testthat::expect_true("LDblock" %in% colnames(result$query_dat))
})
