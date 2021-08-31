test_that("liftover works", {
    data("BST1")
    dat_lifted <- liftover(dat = BST1, build_conversion = "hg19ToHg38")
    testthat::expect_equal(nrow(dat_lifted), nrow(BST1))
})
