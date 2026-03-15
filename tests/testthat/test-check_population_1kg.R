test_that("check_population_1kg translates synonymous populations for phase3", {
    testthat::expect_equal(
        echoLD:::check_population_1kg("AFA", "1KGphase3"),
        "AFR"
    )
    testthat::expect_equal(
        echoLD:::check_population_1kg("HIS", "1KGphase3"),
        "AMR"
    )
    testthat::expect_equal(
        echoLD:::check_population_1kg("CAU", "1KGphase3"),
        "EUR"
    )
})

test_that("check_population_1kg passes through valid populations for phase3", {
    for (pop in c("AFR", "AMR", "EAS", "EUR", "SAS")) {
        testthat::expect_equal(
            echoLD:::check_population_1kg(pop, "1KGphase3"),
            pop,
            info = paste("Failed for population:", pop)
        )
    }
})

test_that("check_population_1kg translates synonymous populations for phase1", {
    testthat::expect_equal(
        echoLD:::check_population_1kg("AFA", "1KGphase1"),
        "AFR"
    )
    testthat::expect_equal(
        echoLD:::check_population_1kg("EAS", "1KGphase1"),
        "ASN"
    )
    testthat::expect_equal(
        echoLD:::check_population_1kg("CAU", "1KGphase1"),
        "EUR"
    )
})

test_that("check_population_1kg handles case insensitivity", {
    testthat::expect_equal(
        echoLD:::check_population_1kg("eur", "1KGphase3"),
        "EUR"
    )
    testthat::expect_equal(
        echoLD:::check_population_1kg("afr", "1KGphase1"),
        "AFR"
    )
})

test_that("check_population_1kg errors on invalid population", {
    testthat::expect_error(
        echoLD:::check_population_1kg("INVALID", "1KGphase3")
    )
    testthat::expect_error(
        echoLD:::check_population_1kg("INVALID", "1KGphase1")
    )
})
