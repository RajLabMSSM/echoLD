test_that("plot_LD works", {
  
    query_dat<- echodata::BST1
    LD_matrix <- echodata::BST1_LD_matrix
    
    p1 <- echoLD::plot_LD(LD_matrix = LD_matrix,
                          query_dat= query_dat 
                          method = "stats")
    testthat::expect_true(all(c("rowInd","colInd") %in% names(p1)))
    
    p2 <- echoLD::plot_LD(LD_matrix = LD_matrix,
                          query_dat= query_dat 
                          method = "gaston")
    testthat::expect_null(p2)
    
    p3 <- echoLD::plot_LD(LD_matrix = LD_matrix,
                          query_dat= query_dat 
                          method = "graphics")
    testthat::expect_null(p3)
})
