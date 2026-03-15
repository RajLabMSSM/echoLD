test_that("fill_NA replaces NAs with 0", {
    mat <- matrix(
        c(1, NA, 0.5, NA, 1, 0.3, 0.5, 0.3, 1),
        nrow = 3,
        dimnames = list(c("rs1", "rs2", "rs3"), c("rs1", "rs2", "rs3"))
    )

    result <- echoLD:::fill_NA(mat, fillNA = 0, verbose = FALSE)

    testthat::expect_false(any(is.na(result)))
    testthat::expect_equal(result["rs1", "rs2"], 0)
    testthat::expect_equal(result["rs1", "rs1"], 1)
})

test_that("fill_NA removes rows/cols named '.'", {
    mat <- matrix(
        1,
        nrow = 3, ncol = 3,
        dimnames = list(c("rs1", ".", "rs3"), c("rs1", ".", "rs3"))
    )

    result <- echoLD:::fill_NA(mat, verbose = FALSE)

    testthat::expect_false("." %in% rownames(result))
    testthat::expect_false("." %in% colnames(result))
    testthat::expect_equal(nrow(result), 2)
    testthat::expect_equal(ncol(result), 2)
})

test_that("fill_NA handles matrix with unique rownames correctly", {
    # fill_NA converts to data.frame internally, which makes rownames unique.
    # Verify that deduplicated results are returned properly.
    mat <- matrix(
        c(1, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 1),
        nrow = 3,
        dimnames = list(c("rs1", "rs2", "rs3"), c("rs1", "rs2", "rs3"))
    )

    result <- echoLD:::fill_NA(mat, verbose = FALSE)

    testthat::expect_equal(nrow(result), 3)
    testthat::expect_equal(ncol(result), 3)
    testthat::expect_false(any(duplicated(rownames(result))))
    testthat::expect_false(any(duplicated(colnames(result))))
})

test_that("fill_NA with NULL fillNA skips NA replacement", {
    mat <- matrix(
        c(1, NA, NA, 1),
        nrow = 2,
        dimnames = list(c("rs1", "rs2"), c("rs1", "rs2"))
    )

    result <- echoLD:::fill_NA(mat, fillNA = NULL, verbose = FALSE)

    testthat::expect_true(any(is.na(result)))
})

test_that("fill_NA preserves values when no NAs present", {
    mat <- matrix(
        c(1, 0.3, 0.3, 1),
        nrow = 2,
        dimnames = list(c("rs1", "rs2"), c("rs1", "rs2"))
    )

    result <- echoLD:::fill_NA(mat, fillNA = 0, verbose = FALSE)

    testthat::expect_equal(result["rs1", "rs2"], 0.3)
    testthat::expect_equal(result["rs1", "rs1"], 1)
})
