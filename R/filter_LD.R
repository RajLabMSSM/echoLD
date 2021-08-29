#' Filter LD
#'
#' @family LD
#' @keywords internal
#' @examples
#' data("BST1")
#' data("LD_matrix")
#' LD_list <- list(LD = LD_matrix, DT = BST1)
#' LD_list <- filter_LD(LD_list, min_r2 = .2)
filter_LD <- function(LD_list,
                      remove_correlates = FALSE,
                      min_r2 = 0,
                      verbose = FALSE) {
    messager("+ FILTER:: Filtering by LD features.", v = verbose)
    dat <- LD_list$DT
    LD_matrix <- LD_list$LD
    if (any(remove_correlates != F)) {
        # remove_correlates <- c("rs76904798"=.2, "rs10000737"=.8)
        for (snp in names(remove_correlates)) {
            thresh <- remove_correlates[[snp]]
            messager("+ FILTER:: Removing correlates of", snp, "at r2 ≥", thresh, v = verbose)
            if (snp %in% row.names(LD_matrix)) {
                correlates <- colnames(LD_matrix[snp, ])[LD_matrix[snp, ] >= sqrt(thresh)]
                LD_matrix <- LD_matrix[
                    (!row.names(LD_matrix) %in% correlates),
                    (!colnames(LD_matrix) %in% correlates)
                ]
            }
        }
    }
    if (min_r2 != 0 & min_r2 != F) {
        messager("+ FILTER:: Removing SNPs that don't correlate with lead SNP at r2 ≤", min_r2, v = verbose)
        LD_list <- subset_common_snps(
            LD_matrix = LD_matrix,
            finemap_dat = dat,
            verbose = F
        )
        dat <- LD_list$DT
        LD_matrix <- LD_list$LD
        lead.snp <- subset(dat, leadSNP)$SNP[1]
        correlates <- colnames(LD_matrix[lead.snp, ])[LD_matrix[lead.snp, ] >= sqrt(min_r2)]
        LD_matrix <- LD_matrix[
            (row.names(LD_matrix) %in% correlates),
            (colnames(LD_matrix) %in% correlates)
        ]
    }
    LD_list <- subset_common_snps(
        LD_matrix = LD_matrix,
        finemap_dat = dat,
        verbose = F
    )
    return(LD_list)
}
