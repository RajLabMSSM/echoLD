#' Filter LD
#'
#' Filter LD
#' @param LD_list List containing SNP-level data (\code{dat}),
#' and LD matrix (\code{LD}).
#' @param remove_correlates A list of SNPs.
#' If provided, all SNPs that correlates with these SNPs (at r2>=\code{min_r2})
#' will be removed from both \code{dat} and \code{LD} list items..
#' @param min_r2 Correlation threshold for \code{remove_correlates}.
#' @param verbose Print messages.
#'
#' @family LD
#' @export
#' @examples
#' LD_list <- list(LD = echodata::BST1_LD_matrix,
#'                 DT = echodata::BST1)
#' LD_list2 <- echoLD::filter_LD(LD_list = LD_list, min_r2 = .2)
filter_LD <- function(LD_list,
                      remove_correlates = FALSE,
                      min_r2 = 0,
                      verbose = FALSE) {
    # Avoid confusing checks
    leadSNP <- NULL

    messager("+ FILTER:: Filtering by LD features.", v = verbose)
   dat <- LD_list$DT
    LD_matrix <- LD_list$LD
    if (any(remove_correlates != FALSE)) {
        # remove_correlates <- c("rs76904798"=.2, "rs10000737"=.8)
        for (snp in names(remove_correlates)) {
            thresh <- remove_correlates[[snp]]
            messager("+ FILTER:: Removing correlates of",
                snp, "at r2 >=", thresh,
                v = verbose
            )
            if (snp %in% rownames(LD_matrix)) {
                select_r2 <- LD_matrix[snp, ]
                correlates <- names(select_r2)[select_r2 >= sqrt(thresh)]
                LD_matrix <- LD_matrix[
                    (!row.names(LD_matrix) %in% correlates),
                    (!colnames(LD_matrix) %in% correlates)
                ]
            }
        }
    }
    if (all((min_r2 != 0) & (min_r2 != FALSE))) {
        messager(
            "+ FILTER:: Removing SNPs that don't correlate with lead SNP",
            "at r2 <=", paste0(min_r2, "."),
            v = verbose
        )
        LD_list <- subset_common_snps(
            LD_matrix = LD_matrix,
            dat = dat,
            verbose = FALSE
        )
       dat<- LD_list$DT
        LD_matrix <- LD_list$LD
        lead.snp <- subset(dat, leadSNP)$SNP[1]
        lead.snp_r2 <- LD_matrix[lead.snp, ]
        correlates <- names(lead.snp_r2)[lead.snp_r2 >= sqrt(min_r2)]
        LD_matrix <- LD_matrix[
            (row.names(LD_matrix) %in% correlates),
            (colnames(LD_matrix) %in% correlates)
        ]
    }
    LD_list <- subset_common_snps(
        LD_matrix = LD_matrix,
        dat = dat,
        verbose = FALSE
    )
    return(LD_list)
}
