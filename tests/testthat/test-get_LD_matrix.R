test_that("get_LD_matrix works", {

    query_dat <-  echodata::BST1[seq(1, 50), ]
    locus_dir <- file.path(tempdir(),  echodata::locus_dir)
    LD_reference <- tempfile(fileext = ".csv")
    utils::write.csv(echodata::BST1_LD_matrix,
                     file = LD_reference,
                     row.names = TRUE)
    LD_list <- get_LD_matrix(
        locus_dir = locus_dir,
        query_dat = query_dat,
        LD_reference = LD_reference)
    testthat::expect_equal(names(LD_list),c("LD","DT","path"))
    testthat::expect_equal(dim(LD_list$LD), c(45,45))
})
