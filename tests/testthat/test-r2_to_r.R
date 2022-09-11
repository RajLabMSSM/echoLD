test_that("r2_to_r works", {
  
    LD_matrix <- echodata::BST1_LD_matrix
    r2r_out <- r2_to_r(LD_matrix = LD_matrix)
    testthat::expect_equal(names(r2r_out),c("LD_matrix","LD_metric"))
    testthat::expect_equal(r2r_out$LD_metric,"r")
    testthat::expect_equal(LD_matrix,r2r_out$LD_matrix)
    
    
    LD_matrix2 <- LD_matrix^2
    r2r_out2 <- r2_to_r(LD_matrix = LD_matrix2)
    testthat::expect_equal(names(r2r_out2),c("LD_matrix","LD_metric"))
    testthat::expect_equal(r2r_out2$LD_metric,"rAbsolute")
    testthat::expect_equal(sqrt(LD_matrix2),r2r_out2$LD_matrix)
})
