test_that("get_locus_vcf_folder creates LD subfolder", {
    locus_dir <- file.path(tempdir(), "test_locus_vcf_folder")
    on.exit(unlink(locus_dir, recursive = TRUE), add = TRUE)

    result <- echoLD:::get_locus_vcf_folder(locus_dir = locus_dir)

    testthat::expect_equal(result, file.path(locus_dir, "LD"))
    testthat::expect_true(dir.exists(result))
})

test_that("get_locus_vcf_folder is idempotent", {
    locus_dir <- file.path(tempdir(), "test_locus_vcf_folder2")
    on.exit(unlink(locus_dir, recursive = TRUE), add = TRUE)

    result1 <- echoLD:::get_locus_vcf_folder(locus_dir = locus_dir)
    result2 <- echoLD:::get_locus_vcf_folder(locus_dir = locus_dir)

    testthat::expect_equal(result1, result2)
    testthat::expect_true(dir.exists(result2))
})
