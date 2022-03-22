test_that("select_vcf_samples works", { 
    
    run_tests <- function(LD_reference = "1KGphase1"){
        superpop <- NULL;
        
       ref <- if(LD_reference=="1KGphase1") {
           echoLD::popDat_1KGphase1
       } else {
           echoLD::popDat_1KGphase3
       }
        superpops <- unique(ref$superpop)
        for(pop in superpops){
            print(pop)
            actual <- echoLD::select_vcf_samples(superpopulation = pop, 
                                                 LD_reference = LD_reference)
            expected <- nrow(subset(ref, superpop==pop))
            testthat::expect_length(actual, expected)
        } 
    }
    
    run_tests(LD_reference = "1KGphase1")
    run_tests(LD_reference = "1KGphase3")
})
