#' Get LD blocks
#' 
#' Identify the LD block in which the lead SNP resides.
#' @return A list with the input data and LD matrix 
#' (\ifelse{html}{\out{r<sup>2</sup>}}{\eqn{r^2}}).
#'
#' @param query_dat SNP-level data table.
#' @param ss \pkg{snpStats} object or LD matrix containing 
#' \ifelse{html}{\out{r}}{\eqn{r}} or 
#' \ifelse{html}{\out{r<sup>2</sup>}}{\eqn{r^2}} values.
#' @param verbose Print messages.
#' @inheritParams adjclust::snpClust
#' @inheritParams adjclust::select
#'
#' @source \href{https://github.com/pneuvial/adjclust}{adjclust GitHub}
#' @export
#' @importFrom Matrix forceSymmetric
get_LD_blocks <- function(query_dat,
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
    query_dat$LDblock <- clusters[query_dat$SNP]
    return(list(
        query_dat= query_dat,
        LD_r2 = fit_clust$fit$data
    ))
}
