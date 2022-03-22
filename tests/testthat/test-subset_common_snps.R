test_that("subset_common_snps works", {
  
    dat <- echodata::BST1
    BST1_LD_matrix <- echodata::BST1_LD_matrix 
    
    out <- echoLD::subset_common_snps(LD_matrix = BST1_LD_matrix,
                                      dat= dat)
    
    testthat::expect_equal(nrow(out$LD), nrow(out$DT))
    testthat::expect_equal(rownames(out$LD), out$query_dat$SNP)
})
