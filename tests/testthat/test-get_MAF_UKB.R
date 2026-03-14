test_that("get_MAF_UKB works", {

    conda_available <- tryCatch(
        echoconda::env_exists(conda_env = "echoR_mini"),
        error = function(e) FALSE
    )
    testthat::skip_if_not(conda_available,
                          message = "echoR_mini conda env not available")
   query_dat<- echodata::BST1
    query_dat$MAF <- NULL
    run_tests <- function(query_dat, query_dat2){
        testthat::expect_true(!"MAF" %in% colnames(query_dat))
        testthat::expect_true("MAF" %in% colnames(query_dat2))
        testthat::expect_true(methods::is(query_dat2,"data.frame"))
        testthat::expect_equal(round(max(query_dat2$MAF),3), 0.5)
        testthat::expect_equal(round(min(query_dat2$MAF),3), 0.001)
    }
    
    #### First try ####
    query_dat2 <- echoLD::get_MAF_UKB(query_dat = query_dat)
    run_tests(query_dat = query_dat,
              query_dat2 = query_dat2)
     
    #### Test whether cached UKB MAF file is used ####
    dat3 <- echoLD::get_MAF_UKB(query_dat = query_dat) 
    run_tests(query_dat = query_dat,
              query_dat2 = dat3)
    out <- testthat::capture_messages(
        code = echoLD::get_MAF_UKB(query_dat = query_dat)
    )
    testthat::expect_equal(out[2],
                           "+ UKB MAF:: Importing pre-existing file\n")
})
