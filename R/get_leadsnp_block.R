#' Identify the LD block in which the lead SNP resides
#'
#'
#' @param verbose Print messages.
#' @inheritParams adjclust::snpClust
#' @inheritParams adjclust::select
#'
#' @source \href{https://github.com/pneuvial/adjclust}{adjclust GitHub}
#' @keywords internal
#' @importFrom adjclust snpClust select
#' @importFrom Matrix forceSymmetric
get_leadsnp_block <- function(dat,
                              ss,
                              pct = 0.15,
                              verbose = TRUE) {
    # Avoid confusing checks 
    leadSNP <- LDblock <- NULL;
    
    dat_LD <- get_LD_blocks(
        dat = dat,
        ss = ss,
        pct = pct,
        verbose = verbose
    )
    dat <- dat_LD$dat
    LD_r2 <- dat_LD$LD_r2

    # Get lead SNP rsid
    if ("leadSNP" %in% colnames(dat)) {
        messager(
            "Returning only SNPs within the same LD block as the lead SNP.",
            v = verbose
        )
        lead_block <- subset(dat, leadSNP == TRUE)$LDblock[1]
        dat <- subset(dat, LDblock == lead_block)
    } else {
        messager("leadSNP column not present. Returning all SNPs.",
            v = verbose
        )
    }
    return(list(
        dat = dat,
        LD_r2 = LD_r2
    ))
}
