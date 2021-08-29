#' Find correlates of the lead GWAS/QTL SNP
get_lead_r2 <- function(finemap_dat,
                        LD_matrix = NULL,
                        fillNA = 0,
                        LD_format = "matrix",
                        verbose = TRUE) {
    if (any(c("r", "r2") %in% colnames(finemap_dat))) {
        finemap_dat <- dplyr::select(finemap_dat, -c(r, r2))
    }
    LD_SNP <- unique(subset(finemap_dat, leadSNP == T)$SNP)
    if (length(LD_SNP) > 1) {
        LD_SNP <- LD_SNP[1]
        warning("More than one lead SNP found. Using only the first one:", LD_SNP, v = verbose)
    }
    # Infer LD data format
    if (LD_format == "guess") {
        LD_format <- if (nrow(LD_matrix) == ncol(LD_matrix) |
            class(LD_matrix)[1] == "dsCMatrix") {
            "matrix"
        } else {
            "df"
        }
    }

    if (LD_format == "matrix") {
        if (is.null(LD_matrix)) {
            messager("+ LD:: No LD_matrix detected. Setting r2=NA", v = verbose)
            dat <- finemap_dat
            dat$r2 <- NA
        } else {
            messager("+ LD:: LD_matrix detected.",
                "Coloring SNPs by LD with lead SNP.",
                v = verbose
            )
            LD_sub <- LD_matrix[, LD_SNP] %>%
                # subset(LD_matrix, select=LD_SNP) %>%
                # subset(select = -c(r,r2)) %>%
                data.table::as.data.table(keep.rownames = T) %>%
                `colnames<-`(c("SNP", "r")) %>%
                dplyr::mutate(r2 = r^2) %>%
                data.table::as.data.table()
            dat <- data.table::merge.data.table(finemap_dat, LD_sub,
                by = "SNP",
                all.x = T
            )
        }
    }
    if (LD_format == "df") {
        LD_sub <- subset(LD_matrix, select = c("SNP", LD_SNP)) %>%
            `colnames<-`(c("SNP", "r")) %>%
            dplyr::mutate(r2 = r^2) %>%
            data.table::as.data.table()
        dat <- data.table::merge.data.table(finemap_dat, LD_sub,
            by = "SNP",
            all.x = T
        )
    }

    if (fillNA != F) {
        dat$r <- tidyr::replace_na(dat$r, fillNA)
        dat$r2 <- tidyr::replace_na(dat$r2, fillNA)
    }
    return(dat)
}
