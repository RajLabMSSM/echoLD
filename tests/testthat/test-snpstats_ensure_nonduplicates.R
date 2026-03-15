test_that("snpstats_ensure_nonduplicates filters to BIM snps", {
    # Create a minimal BIM file
    bim_path <- tempfile(fileext = ".bim")
    on.exit(unlink(bim_path), add = TRUE)

    bim_data <- data.frame(
        CHR = c(1, 1, 1, 1),
        SNP = c("rs1", "rs2", "rs3", "rs4"),
        V3 = c(0, 0, 0, 0),
        POS = c(100, 200, 300, 400),
        A1 = c("A", "C", "G", "T"),
        A2 = c("T", "G", "C", "A")
    )
    data.table::fwrite(bim_data, bim_path, sep = "\t",
                       col.names = FALSE)

    result <- echoLD:::snpstats_ensure_nonduplicates(
        bim_path = bim_path,
        select_snps = c("rs1", "rs3", "rs999"),
        verbose = FALSE
    )

    # rs999 is not in BIM, so should be filtered out
    testthat::expect_equal(sort(result), c("rs1", "rs3"))
})

test_that("snpstats_ensure_nonduplicates removes duplicate SNPs", {
    bim_path <- tempfile(fileext = ".bim")
    on.exit(unlink(bim_path), add = TRUE)

    bim_data <- data.frame(
        CHR = c(1, 1, 1),
        SNP = c("rs1", "rs1", "rs2"),
        V3 = c(0, 0, 0),
        POS = c(100, 100, 200),
        A1 = c("A", "A", "C"),
        A2 = c("T", "T", "G")
    )
    data.table::fwrite(bim_data, bim_path, sep = "\t",
                       col.names = FALSE)

    result <- echoLD:::snpstats_ensure_nonduplicates(
        bim_path = bim_path,
        select_snps = c("rs1", "rs2"),
        verbose = FALSE
    )

    # rs1 appears twice in BIM but should be deduplicated
    testthat::expect_equal(sort(result), c("rs1", "rs2"))
})

test_that("snpstats_ensure_nonduplicates returns NULL when no overlap", {
    bim_path <- tempfile(fileext = ".bim")
    on.exit(unlink(bim_path), add = TRUE)

    bim_data <- data.frame(
        CHR = 1, SNP = "rs1", V3 = 0,
        POS = 100, A1 = "A", A2 = "T"
    )
    data.table::fwrite(bim_data, bim_path, sep = "\t",
                       col.names = FALSE)

    result <- echoLD:::snpstats_ensure_nonduplicates(
        bim_path = bim_path,
        select_snps = c("rs999"),
        verbose = FALSE
    )

    testthat::expect_null(result)
})

test_that("snpstats_ensure_nonduplicates returns NULL when select_snps is NULL", {
    # When select_snps is NULL, the function skips processing
    result <- echoLD:::snpstats_ensure_nonduplicates(
        bim_path = "dummy_path",
        select_snps = NULL,
        verbose = FALSE
    )
    testthat::expect_null(result)
})
