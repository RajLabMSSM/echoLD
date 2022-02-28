test_that("get_UKB_MAF works", {
    
    dat <- echodata::BST1
    dat$MAF <- NULL
    run_tests <- function(dat, dat2){
        testthat::expect_true(!"MAF" %in% colnames(dat))
        testthat::expect_true("MAF" %in% colnames(dat2))
        testthat::expect_true(methods::is(dat2,"data.frame"))
        testthat::expect_equal(round(max(dat2$MAF),3), 0.5)
        testthat::expect_equal(round(min(dat2$MAF),3), 0.001)
    }
    
    #### First try ####
    dat2 <- echoLD::get_UKB_MAF(dat = dat)
    run_tests(dat = dat,
              dat2 = dat2)
     
    #### Test whether cached UKB MAF file is used ####
    dat3 <- echoLD::get_UKB_MAF(dat = dat) 
    run_tests(dat = dat,
              dat2 = dat3)
    out <- testthat::capture_messages(code = echoLD::get_UKB_MAF(dat = dat))
    testthat::expect_equal(out[2],
                           "+ UKB MAF:: Importing pre-existing file\n")
})
