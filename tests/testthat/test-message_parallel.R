test_that("message_parallel runs without error", {
    testthat::expect_no_error(
        echoLD:::message_parallel("test message")
    )
})

test_that("message_parallel concatenates arguments", {
    testthat::expect_no_error(
        echoLD:::message_parallel("part1", "part2", "part3")
    )
})
