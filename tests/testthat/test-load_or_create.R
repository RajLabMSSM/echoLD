test_that("load_or_create works", {
    
    BST1 <- echodata::BST1
    locus_dir <- echodata::locus_dir
    locus_dir <- file.path(tempdir(), locus_dir)
    BST1 <- BST1[seq(1, 50), ]

    run_tests <- function(LD_list) {
        testthat::expect_length(LD_list, 3)
        testthat::expect_equal(nrow(LD_list$LD), ncol(LD_list$LD))
        testthat::expect_lte(nrow(LD_list$LD), nrow(LD_list$query_dat))
        testthat::expect_gte(nrow(LD_list$LD), 40)
        testthat::expect_true(methods::is(LD_list$RDS_path, "character"))
        testthat::expect_true(file.exists(LD_list$RDS_path))
    }

    #### 1000 Genomes: Phase 1 ####
    LD_1kgp1 <- echoLD::load_or_create(
        locus_dir = locus_dir,
       query_dat= BST1,
        LD_reference = "1KGphase1"
    )
    run_tests(LD_1kgp1)

    #### 1000 Genomes: Phase 1 (from storage) ####
    LD_1kgp1 <- echoLD::load_or_create(
        locus_dir = locus_dir,
       query_dat= BST1,
        LD_reference = "1KGphase1"
    )
    run_tests(LD_1kgp1)

    #### 1000 Genomes: Phase 3 ####
    LD_1kgp3 <- echoLD::load_or_create(
        locus_dir = locus_dir,
       query_dat= BST1,
        LD_reference = "1KGphase3",
        remove_tmps = FALSE,
        force_new_LD = TRUE
    )
    run_tests(LD_1kgp3)

    #### Custom VCF ####
    LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
                                package = "echoLD")
    LD_custom <- echoLD::load_or_create(
        locus_dir = locus_dir,
       query_dat= BST1,
        LD_reference = LD_reference
    )
    run_tests(LD_custom)

    # UK Biobank LD
    # LD_ukb<- load_or_create(locus_dir = locus_dir,
    #                        query_dat= BST1,
    #                         LD_reference = "UKB")
    # run_tests(LD_ukb)

    # # Local vcf file
    # vcf_url <- file.path(
    #     "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release",
    #     "20110521/",
    #     paste0("ALL.chr",22,".phase1_release_v3.20101123",
    #            ".snps_indels_svs.genotypes.vcf.gz"))
    # out_paths <- downloadR::download_vcf(vcf_url = vcf_url,
    # #                                      nThread = 1)
    # LD_reference <- file.path(
    #     "/var/folders/zq/h7mtybc533b1qzkys_ttgpth0000gn/T/RtmpQuMo8l",
    #     "results/GWAS/Nalls23andMe_2019/BST1/LD/BST1.1KGphase3.vcf")
    # LD_reference <- "var/folders/zq/h7mtybc533b1qzkys_ttgpth0000gn/T//RtmpQuMo8l/results/GWAS/Nalls23andMe_2019/BST1/LD/BST1.1KGphase3.vcf"
    # file.exists(LD_reference)
    # LD_local <- load_or_create(locus_dir = locus_dir,
    #                           query_dat= BST1,
    #                            LD_reference = LD_reference,
    #                            force_new_LD = TRUE)
})
