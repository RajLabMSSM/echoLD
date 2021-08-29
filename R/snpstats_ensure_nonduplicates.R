snpstats_ensure_nonduplicates <- function(select.snps = NULL,
                                          LD_folder,
                                          plink_prefix = "plink",
                                          nThread = 1,
                                          verbose = TRUE) {
    if (!is.null(select.snps)) {
        bim_path <- file.path(LD_folder, paste0(plink_prefix, ".bim"))
        bim <- data.table::fread(bim_path,
            col.names = c("CHR", "SNP", "V3", "POS", "A1", "A2"),
            stringsAsFactors = FALSE,
            nThread = nThread
        )
        messager("+ LD:snpStats::", nrow(bim), "rows in bim file.", v = verbose)
        bim <- bim[!duplicated(bim$SNP), ]
        select.snps <- select.snps[select.snps %in% unique(bim$SNP)]
        messager("+ LD:snpStats::", length(select.snps),
            "SNPs in select.snps.",
            v = verbose
        )
        select.snps <- if (length(select.snps) == 0) {
            NULL
        } else {
            unique(select.snps)
        }
    }
    return(select.snps)
}
