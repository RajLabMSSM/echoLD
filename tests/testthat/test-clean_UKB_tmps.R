test_that("clean_UKB_tmps removes .gz and .npz files", {
    base_path <- file.path(tempdir(), "test_clean_ukb_base")
    gz_file <- paste0(base_path, ".gz")
    npz_file <- paste0(base_path, ".npz")

    # Create temp files
    writeLines("test", gz_file)
    writeLines("test", npz_file)

    testthat::expect_true(file.exists(gz_file))
    testthat::expect_true(file.exists(npz_file))

    echoLD:::clean_UKB_tmps(URL = base_path, verbose = FALSE)

    testthat::expect_false(file.exists(gz_file))
    testthat::expect_false(file.exists(npz_file))
})

test_that("clean_UKB_tmps handles non-existent files gracefully", {
    base_path <- file.path(tempdir(), "nonexistent_file_12345")

    # Should not error when files don't exist
    testthat::expect_no_error(
        echoLD:::clean_UKB_tmps(URL = base_path, verbose = FALSE)
    )
})

test_that("clean_UKB_tmps removes only existing files", {
    base_path <- file.path(tempdir(), "test_clean_partial")
    gz_file <- paste0(base_path, ".gz")
    npz_file <- paste0(base_path, ".npz")

    # Only create .gz, not .npz
    writeLines("test", gz_file)

    echoLD:::clean_UKB_tmps(URL = base_path, verbose = FALSE)

    testthat::expect_false(file.exists(gz_file))
    testthat::expect_false(file.exists(npz_file))
})
