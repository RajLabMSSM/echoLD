#' Get LD with lead SNP
#' 
#' Add new columns r and r2 containing the degree of LD in each SNP (row)
#'  with the lead GWAS/QTL SNP. 
#'
#' @param query_dat SNP-level data.
#' @param LD_matrix LD matrix.
#' @param fillNA Value to fill NAs with in r/r2 columns.
#' @param LD_format The format of the provided \code{LD_matrix}:
#' "matrix" (wide) or "df" (long).
#' @param verbose Print messages.
#'
#' @returns \link[data.table]{data.table} with the columns r and r2.
#'
#' @export
#' @importFrom dplyr %>% mutate
#' @importFrom data.table as.data.table merge.data.table
#' 
#' @examples
#' query_dat2 <- echoLD::get_lead_r2(query_dat = echodata::BST1,
#'                                   LD_matrix = echodata::BST1_LD_matrix)
get_lead_r2 <- function(query_dat,
                        LD_matrix = NULL,
                        fillNA = 0,
                        LD_format = "matrix",
                        verbose = TRUE) {
    # Avoid confusing checks
    r <- leadSNP <- NULL;

    if (any(c("r", "r2") %in% colnames(query_dat))) {
       query_dat<- query_dat[, -c("r", "r2")]
    }
    LD_SNP <- unique(subset(query_dat, leadSNP)$SNP)
    if (length(LD_SNP) > 1) {
        LD_SNP <- LD_SNP[1]
        warning("More than one lead SNP found. Using only the first one:",
            LD_SNP,
            v = verbose
        )
    }
    #### Infer LD data format ####
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
            messager("+ echoLD:: No LD_matrix detected. Setting r2=NA",
                     v = verbose) 
           query_dat$r2 <- NA
        } else {
            messager("+ echoLD:: LD_matrix detected.",
                "Coloring SNPs by LD with lead SNP.",
                v = verbose
            )
            LD_sub <- LD_matrix[, LD_SNP] %>%
                # subset(LD_matrix, select=LD_SNP) %>%
                # subset(select = -c(r,r2)) %>%
                data.table::as.data.table(keep.rownames  =  TRUE) %>%
                `colnames<-`(c("SNP", "r")) %>%
                dplyr::mutate(r2 = r^2) %>%
                data.table::as.data.table()
           query_dat<- data.table::merge.data.table(query_dat, LD_sub,
                by = "SNP",
                all.x = TRUE
            )
        }
    }
    if (LD_format == "df") {
        LD_sub <- subset(LD_matrix, select = c("SNP", LD_SNP)) %>%
            `colnames<-`(c("SNP", "r")) %>%
            dplyr::mutate(r2 = r^2) %>%
            data.table::as.data.table()
       query_dat<- data.table::merge.data.table(query_dat, LD_sub,
            by = "SNP",
            all.x = TRUE
        )
    }

    if ((fillNA != FALSE) & (sum(is.na(LD_matrix)) > 0)) {
        messager("+ echoLD:: Filling r/r2 NAs with", fillNA, v = verbose)
        query_dat$r[is.na(query_dat$r)] <- fillNA
        query_dat$r2[is.na(query_dat$r2)] <- fillNA
    }
    return(query_dat)
}
