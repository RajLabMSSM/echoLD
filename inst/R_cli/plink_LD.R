#' Calculate LD
#'
#' Use \emph{plink} to calculate LD from a VCF.
#'
#' \code{
#' data("BST1"); data("locus_dir");
#' LD_folder <- file.path(locus_dir, "LD")
#' ld.matrix <- plink_LD(dat = BST1, LD_folder = LD_folder)
#' }
#' @family LD
#' @keywords internal
#' @importFrom data.table merge.data.table
plink_LD <- function(leadSNP = NULL,
                     dat,
                     bim_path = NULL,
                     remove_excess_snps = TRUE,
                     # IMPORTANT! keep this F
                     merge_by_RSID = FALSE,
                     LD_folder,
                     min_r2 = FALSE,
                     min_Dprime = FALSE,
                     remove_correlates = FALSE,
                     fillNA = 0,
                     plink_prefix = "plink",
                     verbose = TRUE,
                     conda_env = NULL) {
    # Avoid conusing checks
    CHR <- POS <- SNP <- SNP_A <- DP <- SNP_B <- R <- NULL

    # Dprime ranges from -1 to 1
    start <- Sys.time()
    if (is.null(leadSNP)) leadSNP <- subset(dat, leadSNP)$SNP[1]
    # Calculate LD
    messager("++ Reading in BIM file...", v = verbose)
    if (is.null(bim_path)) bim_path <- file.path(LD_folder, "plink.bim")
    bim <- data.table::fread(bim_path,
        col.names = c("CHR", "SNP", "V3", "POS", "A1", "A2"),
        stringsAsFactors = F
    )
    if (remove_excess_snps) {
        orig_n <- nrow(bim)
        if (merge_by_RSID) {
            bim.merged <- data.table::merge.data.table(bim,
                dat,
                by = c("SNP")
            )
        } else {
            # Standardize format adn merge
            bim.merged <- data.table::merge.data.table(dplyr::mutate(bim,
                CHR = as.integer(gsub("chr", "", CHR)),
                POS = as.integer(POS)
            ),
            dplyr::mutate(dat,
                CHR = as.integer(gsub("chr", "", CHR)),
                POS = as.integer(POS)
            ),
            by = c("CHR", "POS")
            )
        }
        bim <- subset(bim, SNP %in% bim.merged$SNP.x)
        messager("LD:PLINK:: Removing RSIDs that don't appear in locus subset:", orig_n, "==>", nrow(bim), "SNPs", v = verbose)
    }
    extract_file <- file.path(LD_folder, "SNPs.txt")
    data.table::fwrite(subset(bim, select = "SNP"),
        extract_file,
        col.names = F
    )

    messager("++ Calculating LD", v = verbose)
    ld.matrix <- run_plink_LD(
        bim = bim,
        LD_folder = LD_folder,
        plink_prefix = plink_prefix,
        extract_file = file.path(LD_folder, "SNPs.txt")
    )

    if ((min_Dprime != F) | (min_r2 != F) | (remove_correlates != F)) {
        plink.ld <- dprime_table(
            SNP_list = row.names(ld.matrix),
            LD_folder,
            conda_env = conda_env
        )

        # DPrime filter
        if (min_Dprime != F) {
            messager("+++ Filtering LD Matrix (min_Dprime): Removing SNPs with D' <=", min_Dprime, "for", leadSNP, "(lead SNP).", v = verbose)
            plink.ld <- subset(plink.ld, (SNP_A == leadSNP & DP >= min_Dprime) | (SNP_B == leadSNP & DP >= min_Dprime))
        } else {
            messager("+ min_Dprime == FALSE", v = verbose)
        }

        # R2 filter
        if (min_r2 != F) {
            messager("+++ Filtering LD Matrix (min_r2): Removing SNPs with r <=", min_r2, "for", leadSNP, "(lead SNP).", v = verbose)
            r <- sqrt(min_r2) # PROBLEM: this doesn't give you r, which you need for SUSIE
            plink.ld <- subset(plink.ld, (SNP_A == leadSNP & R >= r) | (SNP_B == leadSNP & R >= r))
        } else {
            messager("+ min_r2 == FALSE", v = verbose)
        }

        # Correlates filter
        if (remove_correlates != F) {
            r2_threshold <- remove_correlates # 0.2
            r <- sqrt(r2_threshold)
            messager("+++ Filtering LD Matrix (remove_correlates): Removing SNPs with R2 >=", r2_threshold, "for", paste(remove_correlates, collapse = ", "), ".", v = verbose)
            plink.ld <- subset(plink.ld, !(SNP_A %in% remove_correlates & R >= r) | (SNP_B %in% remove_correlates & R >= r))
        } else {
            messager("+ remove_correlates == FALSE", v = verbose)
        }

        # Apply filters
        A_list <- unique(plink.ld$SNP_A)
        B_list <- unique(plink.ld$SNP_B)
        snp_list <- unique(c(A_list, B_list))
        ld.matrix <- ld.matrix[row.names(ld.matrix) %in% snp_list, colnames(ld.matrix) %in% snp_list]
        ## Manually remove rare variant
        # ld.matrix <- ld.matrix[rownames(ld.matrix)!="rs34637584", colnames(ld.matrix)!="rs34637584"]
    }
    # !IMPORTANT!: Fill NAs (otherwise susieR will break)
    ld.matrix <- fill_NA(
        LD_matrix = ld.matrix,
        fillNA = fillNA,
        verbose = verbose
    )
    end <- Sys.time()
    messager("+ LD matrix calculated in", round(as.numeric(end - start), 2), "seconds.", v = verbose)
    return(ld.matrix)
}
