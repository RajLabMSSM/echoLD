snpstats_ensure_nonduplicates <- function(bim_path,
                                          select_snps = NULL,
                                          nThread = 1,
                                          verbose = TRUE) {
    if (!is.null(select_snps)) {
        # bim_path <- file.path(LD_folder, paste0(plink_prefix, ".bim"))
        bim <- data.table::fread(bim_path,
            col.names = c("CHR", "SNP", "V3", "POS", "A1", "A2"),
            stringsAsFactors = FALSE,
            nThread = nThread
        )
        messager("+ echoLDLD:snpStats::", nrow(bim), "rows in bim file.",
            v = verbose
        )
        bim <- bim[!duplicated(bim$SNP), ]
        select_snps <- select_snps[select_snps %in% unique(bim$SNP)]
        messager("+ echoLDLD:snpStats::", length(select_snps),
            "SNPs in select_snps",
            v = verbose
        )
        select_snps <- if (length(select_snps) == 0) {
            NULL
        } else {
            unique(select_snps)
        }
    }
    return(select_snps)
}
