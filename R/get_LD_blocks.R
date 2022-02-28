#' Identify the LD block in which the lead SNP resides
#'
#'
#' @return A list with the input data and LD matrix (r^2),
#'
#' @param dat SNP-level data table.
#' @param ss \pkg{snpStats} object or LD matrix (containing r or r^2 values).
#' @param verbose Print messages.
#' @inheritParams adjclust::snpClust
#' @inheritParams adjclust::select
#'
#' @source \href{https://github.com/pneuvial/adjclust}{adjclust GitHub}
#' @export
#' @importFrom Matrix forceSymmetric
get_LD_blocks <- function(dat,
                          ss,
                          stats = c("R.squared", "D.prime"),
                          pct = 0.15,
                          verbose = TRUE) {
    requireNamespace("adjclust")
    
    fit_clust <- compute_LD_blocks(
        x = ss,
        stats = stats,
        pct = pct,
        verbose = verbose
    )
    #### Assign clusters ####
    clusters <- fit_clust$clusters
    dat$LDblock <- clusters[dat$SNP]
    return(list(
        dat = dat,
        LD_r2 = fit_clust$fit$data
    ))
}
