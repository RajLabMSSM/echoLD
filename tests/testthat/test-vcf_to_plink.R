test_that("vcf_to_plink works", {
    
    vcf <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
        package = "echodata")
    paths <- vcf_to_plink(vcf = vcf)
    testthat::expect_true(
        all(file.exists(unlist(paths)[-1]))
    )
})
