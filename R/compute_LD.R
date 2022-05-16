#' Get LD using \pkg{snpStats} package
#'
#' @param LD_folder Locus-specific LD output folder.
#' @inheritParams snpStats::ld
#' @family LD
#' @keywords internal
#' @source
#' \href{https://www.bioconductor.org/packages/release/bioc/html/snpStats.html}{snpStats Bioconductor page}
#' \href{https://www.bioconductor.org/packages/release/bioc/vignettes/snpStats/inst/doc/ld-vignette.pdf}{LD tutorial}
#' @importFrom snpStats read.plink ld
#' @importFrom methods as
compute_LD <- function(ss,
                       select_snps = NULL,
                       stats = c("R"),
                       symmetric = TRUE,
                       depth = "max",
                       as_sparse = TRUE,
                       verbose = TRUE) {
    startLD <- Sys.time()
    #### Subset to select SNPs ####
    if (!is.null(select_snps)) {
        common_snps <- intersect(colnames(ss$genotypes), select_snps)
        ss$genotypes <- ss$genotypes[, common_snps]
        ss$map <- ss$map[ss$map$snp.names %in% select_snps, ]
    }
    messager("echoLD:snpStats:: Computing pairwise LD between",
        formatC(ncol(ss$genotypes), big.mark = ","), "SNPs",
        "across", formatC(nrow(ss$genotypes), big.mark = ","), "individuals",
        paste0("(stats = ", paste(stats, collapse = ", "), ")."),
        v = verbose
    )
    # Compute LD from snpMatrix
    LD_matrix <- snpStats::ld(
        x = ss$genotypes,
        y = ss$genotypes,
        depth = if (depth == "max") ncol(ss$genotypes) else depth,
        stats = stats,
        symmetric = symmetric
    )
    report_time(start = startLD, v = verbose)
    if (length(stats) != 1) {
        LD_matrix <- LD_matrix$R
    }
    if (!is_sparse_matrix(LD_matrix)) {
        LD_matrix <- methods::as(LD_matrix, "sparseMatrix")
    }
    return(LD_matrix)
}
