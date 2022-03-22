#' Get lead SNP block
#' 
#' Identify the LD block in which the lead SNP resides.
#' @param verbose Print messages.
#' @inheritParams adjclust::snpClust
#' @inheritParams adjclust::select
#'
#' @source \href{https://github.com/pneuvial/adjclust}{adjclust GitHub}
#' @keywords internal
#' @importFrom Matrix forceSymmetric
get_leadsnp_block <- function(query_dat,
                              ss,
                              pct = 0.15,
                              verbose = TRUE) {
    # Avoid confusing checks
    leadSNP <- LDblock <- NULL;
    requireNamespace("adjclust")

    dat_LD <- get_LD_blocks(
        query_dat = query_dat,
        ss = ss,
        pct = pct,
        verbose = verbose
    )
    query_dat <- dat_LD$query_dat
    LD_r2 <- dat_LD$LD_r2

    # Get lead SNP rsid
    if ("leadSNP" %in% colnames(query_dat)) {
        messager(
            "Returning only SNPs within the same LD block as the lead SNP.",
            v = verbose
        )
        lead_block <- subset(query_dat, leadSNP == TRUE)$LDblock[1]
        query_dat <- subset(query_dat, LDblock == lead_block)
    } else {
        messager("leadSNP column not present. Returning all SNPs.",
            v = verbose
        )
    }
    return(list(
        query_dat = query_dat,
        LD_r2 = LD_r2
    ))
}
