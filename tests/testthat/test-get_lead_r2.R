test_that("get_lead_r2 works", {
  
    dat <- echodata::BST1
    LD_matrix <- echodata::BST1_LD_matrix
    dat2 <- echoLD::get_lead_r2(dat = dat, LD_matrix = LD_matrix)
    
    testthat::expect_true(methods::is(dat2,"data.frame"))
    testthat::expect_true(!all(c("r","r2") %in% colnames(dat)))
    testthat::expect_true(all(c("r","r2") %in% colnames(dat2)))
    
    #### See if it handles existing columns ####
    dat3 <- echoLD::get_lead_r2(dat = dat2, LD_matrix = LD_matrix)
    testthat::expect_true(all(c("r","r2") %in% colnames(dat2)))
})
