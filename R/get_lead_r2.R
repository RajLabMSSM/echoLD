#' Find correlates of the lead GWAS/QTL SNP
#'
#' @param dat SNP-level data.
#' @param LD_matrix LD matrix.
#' @param fillNA Value to fill NAs with in r/r2 columns.
#' @param LD_format The format of the provided \code{LD_matrix}:
#' "matrix" (wide) or "df" (long).
#' @param verbose Print messages.
#'
#' @keywords internal
#' @importFrom dplyr %>% mutate
#' @importFrom data.table as.data.table merge.data.table
get_lead_r2 <- function(dat,
                        LD_matrix = NULL,
                        fillNA = 0,
                        LD_format = "matrix",
                        verbose = TRUE) {
    # Avoid confusing checks
    r <- r2 <- leadSNP <- NULL

    if (any(c("r", "r2") %in% colnames(dat))) {
        dat <- dat[, -c("r", "r2")]
    }
    LD_SNP <- unique(subset(dat, leadSNP)$SNP)
    if (length(LD_SNP) > 1) {
        LD_SNP <- LD_SNP[1]
        warning("More than one lead SNP found. Using only the first one:",
            LD_SNP,
            v = verbose
        )
    }
    # Infer LD data format
    if (LD_format == "guess") {
        LD_format <- if (nrow(LD_matrix) == ncol(LD_matrix) |
            (is_sparse_matrix(LD_matrix))) {
            "matrix"
        } else {
            "df"
        }
    }

    if (LD_format == "matrix") {
        if (is.null(LD_matrix)) {
            messager("+ LD:: No LD_matrix detected. Setting r2=NA", v = verbose)
            dat <- dat
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
            dat <- data.table::merge.data.table(dat, LD_sub,
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
        dat <- data.table::merge.data.table(dat, LD_sub,
            by = "SNP",
            all.x = T
        )
    }

    if ((fillNA != FALSE) & (sum(is.na(LD_matrix)) > 0)) {
        messager("+ LD:: Filling r/r2 NAs with", fillNA, v = verbose)
        dat$r[is.na(dat$r)] <- fillNA
        dat$r2[is.na(dat$r2)] <- fillNA
    }
    return(dat)
}
