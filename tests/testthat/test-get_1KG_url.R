test_that("get_1KG_url constructs phase3 remote URL", {
    result <- echoLD:::get_1KG_url(
        LD_reference = "1KGphase3",
        chrom = 4,
        verbose = FALSE
    )
    testthat::expect_true(grepl("phase3", result))
    testthat::expect_true(grepl("chr4", result))
    testthat::expect_true(grepl("\\.vcf\\.gz$", result))
    testthat::expect_true(grepl("ftp://", result))
})

test_that("get_1KG_url constructs phase1 remote URL", {
    result <- echoLD:::get_1KG_url(
        LD_reference = "1KGphase1",
        chrom = 22,
        verbose = FALSE
    )
    testthat::expect_true(grepl("phase1", result))
    testthat::expect_true(grepl("chr22", result))
    testthat::expect_true(grepl("\\.vcf\\.gz$", result))
    testthat::expect_true(grepl("20110521", result))
})

test_that("get_1KG_url uses local_storage when provided", {
    local_path <- "/data/1kg_vcfs"

    result_p3 <- echoLD:::get_1KG_url(
        LD_reference = "1KGphase3",
        chrom = 1,
        local_storage = local_path,
        verbose = FALSE
    )
    testthat::expect_true(grepl(local_path, result_p3))
    testthat::expect_false(grepl("ftp://", result_p3))

    result_p1 <- echoLD:::get_1KG_url(
        LD_reference = "1KGphase1",
        chrom = 1,
        local_storage = local_path,
        verbose = FALSE
    )
    testthat::expect_true(grepl(local_path, result_p1))
    testthat::expect_false(grepl("ftp://", result_p1))
})

test_that("get_1KG_url is case insensitive", {
    r1 <- echoLD:::get_1KG_url(
        LD_reference = "1KGphase3",
        chrom = 1,
        verbose = FALSE
    )
    r2 <- echoLD:::get_1KG_url(
        LD_reference = "1KGPHASE3",
        chrom = 1,
        verbose = FALSE
    )
    testthat::expect_equal(r1, r2)
})
