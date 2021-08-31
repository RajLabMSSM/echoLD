#' Subset LD matrix and dataframe to only their shared SNPs
#'
#' Find the SNPs that are shared between an LD matrix and another data.frame with a `SNP` column.
#' Then remove any non-shared SNPs from both objects.
#'
#' \code{
#' data("BST1")
#' data("BST1_LD_matrix")
#' dat <- BST1
#' out <- echoLD:::subset_common_snps(LD_matrix = BST1_LD_matrix, dat = BST1)
#' }
#' @family SNP filters
#' @return data.frame
#' @keywords internal
subset_common_snps <- function(LD_matrix,
                               dat,
                               fillNA = 0,
                               verbose = F) {
    messager("+ Subsetting LD matrix and dat to common SNPs...", v = verbose)
    # Remove duplicate SNPs
    LD_matrix <- data.frame(as.matrix(LD_matrix))
    LD_matrix <- fill_NA(
        LD_matrix = LD_matrix,
        fillNA = fillNA,
        verbose = verbose
    )
    ld.snps <- unique(c(row.names(LD_matrix), colnames(LD_matrix)))

    # Remove duplicate SNPs
    dat <- dat[!base::duplicated(dat$SNP), ]
    fm.snps <- dat$SNP
    common.snps <- base::intersect(ld.snps, fm.snps)
    if (length(common.snps) == 0) stop("No overlapping RSIDs between LD_matrix and dat")
    messager("+ LD_matrix =", length(ld.snps), "SNPs.", v = verbose)
    messager("+ dat =", length(fm.snps), "SNPs.", v = verbose)
    messager("+", length(common.snps), "SNPs in common.", v = verbose)
    # Subset/order LD matrix
    new_LD <- LD_matrix[common.snps, common.snps]

    # Subset/order dat
    dat <- data.frame(dat)
    row.names(dat) <- dat$SNP
    new_DT <- unique(data.table::as.data.table(dat[common.snps, ]))
    # Reassign the lead SNP if it's missing
    # new_DT <- assign_lead_SNP(new_DT, verbose = verbose)
    # Check dimensions are correct
    if (nrow(new_DT) != nrow(new_LD)) {
        warning("+ LD_matrix and dat do NOT have the same number of SNPs.", v = verbose)
        warning("+ LD_matrix SNPs = ", nrow(new_LD), "; dat = ", nrow(dat), v = verbose)
    }
    return(list(
        LD = as.matrix(new_LD),
        DT = new_DT
    ))
}
