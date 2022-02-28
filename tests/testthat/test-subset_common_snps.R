test_that("subset_common_snps works", {
  
    BST1 <- echodata::BST1
    BST1_LD_matrix <- echodata::BST1_LD_matrix
    dat <- BST1
    out <- echoLD::subset_common_snps(LD_matrix = BST1_LD_matrix,
                                      dat = BST1)
    
    testthat::expect_equal(nrow(out$LD), nrow(out$DT))
    testthat::expect_equal(rownames(out$LD), out$DT$SNP)
})
