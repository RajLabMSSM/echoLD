test_that("save_LD_matrix round-trips correctly as sparse", {
    # Create a small mock LD matrix
    snps <- paste0("rs", seq_len(5))
    ld_mat <- matrix(0, nrow = 5, ncol = 5,
                     dimnames = list(snps, snps))
    diag(ld_mat) <- 1
    ld_mat[1, 2] <- ld_mat[2, 1] <- 0.8
    ld_mat[1, 3] <- ld_mat[3, 1] <- 0.4

    dat <- data.table::data.table(
        SNP = snps,
        CHR = 1,
        POS = seq(100, 500, by = 100),
        P = runif(5),
        leadSNP = c(TRUE, rep(FALSE, 4))
    )

    locus_dir <- file.path(tempdir(), "test_save_LD")
    on.exit(unlink(locus_dir, recursive = TRUE), add = TRUE)

    result <- echoLD:::save_LD_matrix(
        LD_matrix = ld_mat,
        dat = dat,
        locus_dir = locus_dir,
        LD_reference = "test_ref",
        as_sparse = TRUE,
        subset_common = TRUE,
        verbose = FALSE
    )

    testthat::expect_type(result, "list")
    testthat::expect_true("LD" %in% names(result))
    testthat::expect_true("DT" %in% names(result))
    testthat::expect_true("path" %in% names(result))
    testthat::expect_true(file.exists(result$path))
    testthat::expect_true(echoLD:::is_sparse_matrix(result$LD))
})

test_that("save_LD_matrix saves dense matrix when as_sparse=FALSE", {
    snps <- paste0("rs", seq_len(3))
    ld_mat <- diag(3)
    dimnames(ld_mat) <- list(snps, snps)

    dat <- data.table::data.table(
        SNP = snps,
        CHR = 1,
        POS = c(100, 200, 300),
        P = c(0.01, 0.5, 0.9),
        leadSNP = c(TRUE, FALSE, FALSE)
    )

    locus_dir <- file.path(tempdir(), "test_save_LD_dense")
    on.exit(unlink(locus_dir, recursive = TRUE), add = TRUE)

    result <- echoLD:::save_LD_matrix(
        LD_matrix = ld_mat,
        dat = dat,
        locus_dir = locus_dir,
        LD_reference = "test_dense",
        as_sparse = FALSE,
        subset_common = TRUE,
        verbose = FALSE
    )

    testthat::expect_true(file.exists(result$path))

    # Read back and verify
    saved <- readRDS(result$path)
    testthat::expect_false(echoLD:::is_sparse_matrix(saved))
})
