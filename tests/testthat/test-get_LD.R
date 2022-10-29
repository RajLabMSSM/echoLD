test_that("get_LD works", {
    
    query_dat <- echodata::BST1[seq(1, 50), ]
    locus_dir <- echodata::locus_dir
    locus_dir <- file.path(tempdir(), locus_dir) 

    run_tests <- function(LD_list) {
        testthat::expect_length(LD_list, 3)
        testthat::expect_equal(nrow(LD_list$LD), ncol(LD_list$LD))
        testthat::expect_lte(nrow(LD_list$LD), nrow(LD_list$DT))
        testthat::expect_gte(nrow(LD_list$LD), 40)
        testthat::expect_true(methods::is(LD_list$path, "character"))
        testthat::expect_true(file.exists(LD_list$path))
    } 
    
    #### 1000 Genomes: Phase 1 ####
    LD_1kgp1 <- echoLD::get_LD(
        locus_dir = locus_dir,
        query_dat = query_dat,
        LD_reference = "1KGphase1"
    )
    run_tests(LD_1kgp1)

    #### 1000 Genomes: Phase 1 (from storage) ####
    LD_1kgp1 <- echoLD::get_LD(
        locus_dir = locus_dir,
        query_dat = query_dat,
        LD_reference = "1KGphase1"
    )
    run_tests(LD_1kgp1)

    #### 1000 Genomes: Phase 3 ####
    LD_1kgp3 <- echoLD::get_LD(
        locus_dir = locus_dir,
        query_dat= query_dat,
        LD_reference = "1KGphase3",
        remove_tmps = FALSE,
        force_new_LD = TRUE
    )
    run_tests(LD_1kgp3)

    #### Custom VCF ####
    LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
                                package = "echodata")
    LD_custom <- echoLD::get_LD(
        locus_dir = locus_dir,
        query_dat= query_dat,
        LD_reference = LD_reference
    )
    run_tests(LD_custom)

    #### UK Biobank ####
    LD_ukb <- echoLD::get_LD(locus_dir = locus_dir,
                             query_dat = query_dat,
                             download_method = "download.file",
                             LD_reference = "UKB")
    run_tests(LD_ukb)

    #### Local vcf file ####
    query_dat <- echodata::BST1[seq(1, 50), ]
    locus_dir <- echodata::locus_dir
    locus_dir <- file.path(tempdir(), locus_dir)
    LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
        package = "echodata")
    LD_list_local <- get_LD(locus_dir = locus_dir,
                            query_dat = query_dat,
                            LD_reference = LD_reference)
    run_tests(LD_list = LD_list_local)
    
    #### Remote vcf file ####  
    LD_reference <- paste(
        "https://github.com/RajLabMSSM/echodata/raw/main",
        "inst/extdata/BST1.1KGphase3.vcf.bgz",sep="/"
    )  
    LD_list_remote <- get_LD(locus_dir = locus_dir,
                             query_dat= query_dat,
                             LD_reference = LD_reference,
                             force_new_LD = TRUE)
    run_tests(LD_list = LD_list_remote)
    
    
    #### Local matrix file #### 
    LD_reference <- tempfile(fileext = ".csv")
    utils::write.csv(echodata::BST1_LD_matrix,
                     file = LD_reference,
                     row.names = TRUE)
    LD_list_matrix_local <- get_LD_matrix(
        locus_dir = locus_dir,
        query_dat = query_dat,
        LD_reference = LD_reference)
    run_tests(LD_list = LD_list_matrix_local)
    
    
    #### Remote matrix file #### 
    LD_reference <- 
        "https://github.com/RajLabMSSM/echodata/raw/main/data/BST1_LD_matrix.rda" 
    LD_list_matrix_remote <- get_LD_matrix(
        locus_dir = locus_dir,
        query_dat = query_dat,
        LD_reference = LD_reference)
    run_tests(LD_list = LD_list_matrix_remote) 
})
