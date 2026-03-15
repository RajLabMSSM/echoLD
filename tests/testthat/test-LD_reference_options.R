test_that("LD_reference_options returns all options when NULL", {
    opts <- echoLD:::LD_reference_options(LD_reference = NULL)

    testthat::expect_type(opts, "list")
    testthat::expect_true("ukb" %in% names(opts))
    testthat::expect_true("1kg" %in% names(opts))
    testthat::expect_true("vcf" %in% names(opts))
    testthat::expect_true("matrix" %in% names(opts))
})

test_that("LD_reference_options identifies UKB", {
    result <- echoLD:::LD_reference_options(
        LD_reference = "UKB",
        verbose = FALSE
    )
    testthat::expect_equal(result, "ukb")
})

test_that("LD_reference_options identifies 1KG references", {
    r1 <- echoLD:::LD_reference_options(
        LD_reference = "1KGphase1",
        verbose = FALSE
    )
    r3 <- echoLD:::LD_reference_options(
        LD_reference = "1KGphase3",
        verbose = FALSE
    )
    testthat::expect_equal(r1, "1kg")
    testthat::expect_equal(r3, "1kg")
})

test_that("LD_reference_options identifies VCF files", {
    for (ext in c(".vcf", ".vcf.gz", ".vcf.bgz")) {
        result <- echoLD:::LD_reference_options(
            LD_reference = paste0("/path/to/file", ext),
            verbose = FALSE
        )
        testthat::expect_equal(result, "vcf",
                               info = paste("Failed for extension:", ext))
    }
})

test_that("LD_reference_options identifies matrix files", {
    for (ext in c(".rds", ".rda", ".csv", ".tsv", ".txt")) {
        result <- echoLD:::LD_reference_options(
            LD_reference = paste0("/path/to/file", ext),
            verbose = FALSE
        )
        testthat::expect_equal(result, "matrix",
                               info = paste("Failed for extension:", ext))
    }
})

test_that("LD_reference_options with as_subgroups returns subgroups", {
    opts <- echoLD:::LD_reference_options(
        LD_reference = NULL,
        as_subgroups = TRUE
    )
    testthat::expect_true("r" %in% names(opts))
    testthat::expect_true("table" %in% names(opts))
    testthat::expect_true("Matrix Market" %in% names(opts))
    # "matrix" should be removed when as_subgroups is TRUE
    testthat::expect_false("matrix" %in% names(opts))
})

test_that("LD_reference_options subgroup identifies R files", {
    result <- echoLD:::LD_reference_options(
        LD_reference = "/path/to/file.rds",
        as_subgroups = TRUE,
        verbose = FALSE
    )
    testthat::expect_equal(result, "r")
})

test_that("LD_reference_options subgroup identifies table files", {
    result <- echoLD:::LD_reference_options(
        LD_reference = "/path/to/file.csv",
        as_subgroups = TRUE,
        verbose = FALSE
    )
    testthat::expect_equal(result, "table")
})

test_that("LD_reference_options subgroup identifies Matrix Market files", {
    result <- echoLD:::LD_reference_options(
        LD_reference = "/path/to/file.mtx",
        as_subgroups = TRUE,
        verbose = FALSE
    )
    testthat::expect_equal(result, "Matrix Market")
})
