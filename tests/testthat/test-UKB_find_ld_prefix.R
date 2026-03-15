test_that("UKB_find_ld_prefix returns correct file name", {
    result <- echoLD:::UKB_find_ld_prefix(
        chrom = 10,
        min_pos = 135000001,
        verbose = FALSE
    )
    testthat::expect_true(grepl("^chr10_", result))
    testthat::expect_true(grepl("_\\d+$", result))
})

test_that("UKB_find_ld_prefix handles chromosome 1 start", {
    result <- echoLD:::UKB_find_ld_prefix(
        chrom = 1,
        min_pos = 500000,
        verbose = FALSE
    )
    testthat::expect_equal(result, "chr1_1_3000001")
})

test_that("UKB_find_ld_prefix handles different chromosomes", {
    r1 <- echoLD:::UKB_find_ld_prefix(chrom = 1, min_pos = 5000000,
                                       verbose = FALSE)
    r22 <- echoLD:::UKB_find_ld_prefix(chrom = 22, min_pos = 5000000,
                                        verbose = FALSE)
    testthat::expect_true(grepl("^chr1_", r1))
    testthat::expect_true(grepl("^chr22_", r22))
    # Same position should give same window offset
    testthat::expect_equal(
        gsub("chr\\d+_", "", r1),
        gsub("chr\\d+_", "", r22)
    )
})

test_that("UKB_find_ld_prefix 3Mb windows are correct", {
    # Position at exactly 2,000,001 should be in the 2M-5M window
    result <- echoLD:::UKB_find_ld_prefix(
        chrom = 5,
        min_pos = 2000001,
        verbose = FALSE
    )
    testthat::expect_equal(result, "chr5_2000001_5000001")
})
