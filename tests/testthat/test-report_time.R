test_that("report_time runs without error", {
    start <- Sys.time()
    testthat::expect_no_error(
        echoLD:::report_time(start = start, v = FALSE)
    )
})

test_that("report_time produces a message when v=TRUE", {
    start <- Sys.time()
    testthat::expect_message(
        echoLD:::report_time(start = start, v = TRUE)
    )
})
