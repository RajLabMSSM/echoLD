test_that("get_rds_path constructs correct path", {
    result <- echoLD:::get_rds_path(
        locus_dir = "/data/locus_A",
        LD_reference = "UKB"
    )
    testthat::expect_equal(result, "/data/locus_A/LD/locus_A.UKB_LD.RDS")
})

test_that("get_rds_path handles nested locus_dir", {
    result <- echoLD:::get_rds_path(
        locus_dir = "/data/project/results/BST1",
        LD_reference = "1KGphase3"
    )
    testthat::expect_equal(
        result,
        "/data/project/results/BST1/LD/BST1.1KGphase3_LD.RDS"
    )
})

test_that("get_rds_path uses basename for LD_reference paths", {
    result <- echoLD:::get_rds_path(
        locus_dir = "/data/locus_A",
        LD_reference = "/some/path/custom_r"
    )
    testthat::expect_equal(
        result,
        "/data/locus_A/LD/locus_A.custom_r_LD.RDS"
    )
})
