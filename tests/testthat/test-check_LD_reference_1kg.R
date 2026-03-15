test_that("check_LD_reference_1kg accepts valid references", {
    testthat::expect_equal(
        echoLD:::check_LD_reference_1kg("1kgphase1"),
        "1kgphase1"
    )
    testthat::expect_equal(
        echoLD:::check_LD_reference_1kg("1kgphase3"),
        "1kgphase3"
    )
})

test_that("check_LD_reference_1kg lowercases input", {
    testthat::expect_equal(
        echoLD:::check_LD_reference_1kg("1KGphase1"),
        "1kgphase1"
    )
    testthat::expect_equal(
        echoLD:::check_LD_reference_1kg("1KGphase3"),
        "1kgphase3"
    )
})

test_that("check_LD_reference_1kg uses first element of vector", {
    testthat::expect_equal(
        echoLD:::check_LD_reference_1kg(c("1KGphase3", "1KGphase1")),
        "1kgphase3"
    )
})

test_that("check_LD_reference_1kg rejects invalid references", {
    testthat::expect_error(
        echoLD:::check_LD_reference_1kg("UKB")
    )
    testthat::expect_error(
        echoLD:::check_LD_reference_1kg("invalid")
    )
})
