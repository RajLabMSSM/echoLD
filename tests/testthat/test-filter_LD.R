test_that("filter_LD works", {
 
    BST1 <- echodata::BST1
    BST1_LD_matrix <- echodata::BST1_LD_matrix
    LD_list <- list(LD = BST1_LD_matrix, DT = BST1)
    LD_list2 <- echoLD::filter_LD(LD_list, min_r2 = .2)
    
    testthat::expect_gte(nrow(LD_list$LD), nrow(LD_list2$LD))
    testthat::expect_gte(nrow(LD_list$DT), nrow(LD_list2$DT))
    testthat::expect_equal(nrow(LD_list2$LD), nrow(LD_list2$DT))
})
