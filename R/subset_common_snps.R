#' Subset LD matrix and dataframe to only their shared SNPs
#'
#' Find the SNPs that are shared between an LD matrix and another data.frame 
#' with a `SNP` column. Then remove any non-shared SNPs from both objects.
#' @param LD_matrix LD matrix. 
#' @inheritParams load_or_create
#'
#' @family SNP filters
#' @return data.frame
#' @export
#' @importFrom data.table as.data.table
#' @examples 
#' out <- echoLD::subset_common_snps(LD_matrix = echodata::BST1_LD_matrix,
#'                                   query_dat = echodata::BST1)
subset_common_snps <- function(LD_matrix,
                               query_dat,
                               fillNA = 0,
                               verbose = FALSE) {
    messager("+ Subsetting LD matrix and query_dat to common SNPs...",
             v = verbose)
    # Remove duplicate SNPs
    LD_matrix <- data.frame(as.matrix(LD_matrix))
    LD_matrix <- fill_NA(
        LD_matrix = LD_matrix,
        fillNA = fillNA,
        verbose = verbose
    )
    ld.snps <- unique(c(row.names(LD_matrix), colnames(LD_matrix)))

    # Remove duplicate SNPs
    query_dat <- query_dat[!base::duplicated(query_dat$SNP), ]
    fm.snps <- query_dat$SNP
    common.snps <- base::intersect(ld.snps, fm.snps)
    if (length(common.snps) == 0) {
        stop("No overlapping RSIDs between LD_matrix and query_dat")
    }
    messager("+ LD_matrix =", length(ld.snps), "SNPs.", v = verbose)
    messager("+ query_dat =", length(fm.snps), "SNPs.", v = verbose)
    messager("+", length(common.snps), "SNPs in common.", v = verbose)
    # Subset/order LD matrix
    new_LD <- LD_matrix[common.snps, common.snps]

    # Subset/order query_dat
    query_dat <- data.frame(query_dat)
    row.names(query_dat) <- query_dat$SNP
    new_query_dat <- unique(data.table::as.data.table(query_dat[common.snps, ]))
    # Reassign the lead SNP if it's missing
    # new_query_dat <- assign_lead_SNP(new_query_dat, verbose = verbose)
    # Check dimensions are correct
    if (nrow(new_query_dat) != nrow(new_LD)) {
        warning("+ LD_matrix and query_dat do NOT",
                " have the same number of SNPs.")
        warning("+ LD_matrix SNPs = ", nrow(new_LD), "; query_dat = ",
                nrow(query_dat))
    }
    return(list(
        LD = as.matrix(new_LD),
        DT = new_query_dat
    ))
}
