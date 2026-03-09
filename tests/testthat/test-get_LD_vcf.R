test_that("get_LD_vcf works", {
  
    run_tests <- function(LD_list) {
        testthat::expect_length(LD_list, 3)
        testthat::expect_equal(nrow(LD_list$LD), ncol(LD_list$LD))
        testthat::expect_lte(nrow(LD_list$LD), nrow(LD_list$DT))
        testthat::expect_gte(nrow(LD_list$LD), 40)
        testthat::expect_true(methods::is(LD_list$path, "character"))
        testthat::expect_true(file.exists(LD_list$path))
    }
    
    query_dat <-  echodata::BST1[seq(1, 50), ]
    locus_dir <- echodata::locus_dir
    locus_dir <- file.path(tempdir(), locus_dir)
    LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
        package = "echodata")
    LD_list <- get_LD_vcf(
        locus_dir = locus_dir,
        query_dat = query_dat,
        LD_reference = LD_reference)
    run_tests(LD_list = LD_list)
})
