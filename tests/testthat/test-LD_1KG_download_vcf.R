test_that("get_LD_1KG_download_vcf works", {
  
    query_dat <- echodata::BST1
    locus_dir <- file.path(tempdir(), echodata::locus_dir)
    query_granges <- echotabix::construct_query(query_dat=query_dat)
    
    ##### Select by sample ####
    samples1 <- c("HG00097","HG00099","HG00100","HG00101","HG00102") 
    vcf1 <- echoLD:::get_LD_1KG_download_vcf(
        query_granges = query_granges,
        LD_reference = "1KGphase1",
        samples = samples1,
        locus_dir = locus_dir, 
        query_save = FALSE,
        force_new = TRUE)
    testthat::expect_equal(dim(vcf1), c(6177,length(samples1)))
    
    ##### Select by superpopulation and samples #### 
    samples2 <- c("HG00553","HG00554","HG00637")
    vcf2 <- echoLD:::get_LD_1KG_download_vcf(
        query_granges = query_granges,
        LD_reference = "1KGphase1",
        samples = samples2,
        superpopulation = "AMR",
        locus_dir = locus_dir, 
        query_save = FALSE,
        force_new = TRUE)
    testthat::expect_equal(dim(vcf2), c(6177,length(samples2)))
})
