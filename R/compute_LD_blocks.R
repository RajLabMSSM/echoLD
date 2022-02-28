#' Compute LD blocks
#'
#' Compute LD blocks using \link[adjclust]{snpClust}.
#'
#' @param verbose Print messages.
#' @inheritParams adjclust::snpClust
#' @inheritParams adjclust::select
#'
#' @source \href{https://github.com/pneuvial/adjclust}{adjclust GitHub}
#' @keywords internal
#' @importFrom Matrix forceSymmetric
compute_LD_blocks <- function(x,
                              stats = c("R.squared", "D.prime"),
                              type = c("capushe", "bstick"),
                              k.max = NULL,
                              pct = 0.15,
                              verbose = TRUE) {
    requireNamespace("adjclust")
    
    startLDB <- Sys.time()
    type <- tolower(type[1])
    stats <- stats[1]
    if (is_sparse_matrix(x)) {
        if (min(x) < 0) x <- x^2
        x <- Matrix::forceSymmetric(x)
    } else {
        x <- x$genotypes
    }
    messager("echoLD:: Computing adjacency matrix.", v = verbose)
    fit <- adjclust::snpClust(
        x = x,
        stats = stats
    )
    messager("echoLD:: Clustering LD blocks using the", type, "method.", v = verbose)
    clusters <- adjclust::select(
        x = fit,
        type = tolower(type[1]),
        k.max = k.max,
        pct = pct
    )
    messager("SNPs grouped into", length(unique(clusters)), "clusters.",
        v = verbose
    )
    #### Explicitly set k ####
    # adjclust::cutree_chac(fit, k = 10)
    report_time(start = startLDB, v = verbose)
    return(list(
        fit = fit,
        clusters = clusters
    ))
}
