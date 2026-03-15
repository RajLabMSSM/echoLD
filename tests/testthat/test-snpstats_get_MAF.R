test_that("snpstats_get_MAF returns existing MAF when present", {
    dat <- data.table::data.table(
        SNP = c("rs1", "rs2"),
        CHR = c(1, 1),
        POS = c(100, 200),
        MAF = c(0.1, 0.2)
    )

    # When MAF column already exists and force_new_maf=FALSE,
    # should return data as-is.
    result <- echoLD:::snpstats_get_MAF(
        query_dat = dat,
        ss = NULL, # won't be used
        force_new_maf = FALSE,
        verbose = FALSE
    )

    testthat::expect_true("MAF" %in% colnames(result))
    testthat::expect_equal(nrow(result), 2)
})
