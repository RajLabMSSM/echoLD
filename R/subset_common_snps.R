#' Subset LD matrix and dataframe to only their shared SNPs
#'
#' Find the SNPs that are shared between an LD matrix and another data.frame 
#' with a "SNP" column. Then remove any non-shared SNPs from both objects.
#' @param LD_matrix LD matrix. 
#' @param dat SNP-level summary statistics subset 
#' to query the LD panel with.
#' @param as_sparse Convert \code{LD_matrix} to sparse matrix before returning.
#' @inheritParams get_LD
#'
#' @family SNP filters
#' @return data.frame
#' @export
#' @importFrom data.table as.data.table
#' @examples 
#' out <- echoLD::subset_common_snps(LD_matrix = echodata::BST1_LD_matrix,
#'                                   dat = echodata::BST1)
subset_common_snps <- function(LD_matrix,
                               dat,
                               fillNA = 0,
                               as_sparse = TRUE,
                               verbose = FALSE) {
    messager("+ Subsetting LD matrix and dat to common SNPs...",
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
    dat <- data.table::copy(data.table::as.data.table(dat))
    if(!"SNP" %in% colnames(dat)) stop("Could not find SNP column in dat.")
    dat <- dat[!base::duplicated(dat$SNP), ]
    fm.snps <- dat$SNP
    common.snps <- base::intersect(ld.snps, fm.snps)
    if (length(common.snps) == 0) {
        stop("No overlapping RSIDs between LD_matrix and dat")
    }
    messager("+ LD_matrix =", length(ld.snps), "SNPs.", v = verbose)
    messager("+ dat =", length(fm.snps), "SNPs.", v = verbose)
    messager("+", length(common.snps), "SNPs in common.", v = verbose)
    # Subset/order LD matrix
    new_LD <- LD_matrix[common.snps, common.snps]
    
    # Subset/order dat
    data.table::setkeyv(dat, "SNP")
    new_dat <- unique(dat[common.snps, ])
    # Reassign the lead SNP if it's missing
    # new_dat <- assign_lead_SNP(new_dat, verbose = verbose)
    # Check dimensions are correct
    if (nrow(new_dat) != nrow(new_LD)) {
        warning("+ LD_matrix and dat do NOT",
                " have the same number of SNPs.")
        warning("+ LD_matrix SNPs = ", nrow(new_LD), "; dat = ",
                nrow(dat))
    }
    #### Convert to sparse ####
    if(as_sparse){
        new_LD <- to_sparse(X = new_LD,
                            verbose = verbose)
    }
    return(list(
        LD = new_LD,
        DT = new_dat
    ))
}
