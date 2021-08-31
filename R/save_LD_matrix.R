#' Save LD matrix
#'
#' Save an LD matrix after initial pre-processing.
#'
#' \code{
#' #data("BST1")
#' #data("BST1_LD_matrix")
#' #data("locus_dir")
#' #locus_dir <- file.path(tempdir(),locus_dir)
#' #LD_list <- save_LD_matrix(
#' #    LD_matrix = BST1_LD_matrix,
#' #    dat = BST1,
#' #    locus_dir = locus_dir,
#' #    LD_reference = "UKB")
#'
#' #LD_list <- save_LD_matrix(
#' #    LD_matrix = BST1_LD_matrix,
#' #    dat = BST1,
#' #    locus_dir = locus_dir,
#' #    LD_reference = "custom_vcf")
#' }
#' @family LD
#' @keywords internal
save_LD_matrix <- function(LD_matrix,
                           dat,
                           locus_dir,
                           fillNA = 0,
                           LD_reference,
                           subset_common = TRUE,
                           as_sparse = TRUE,
                           verbose = TRUE) {
    RDS_path <- get_rds_path(
        locus_dir = locus_dir,
        LD_reference = basename(LD_reference)
    )
    messager("+ LD:: Saving LD matrix ==>", RDS_path, v = verbose)
    if (subset_common) {
        sub.out <- subset_common_snps(
            LD_matrix = LD_matrix,
            fillNA = fillNA,
            dat = dat,
            verbose = FALSE
        )
        LD_matrix <- sub.out$LD
        dat <- sub.out$DT
    }
    messager(dim(LD_matrix)[1], "x", dim(LD_matrix)[2],
        "LD_matrix", if (as_sparse) "(sparse)" else NULL,
        v = verbose
    )

    dir.create(dirname(RDS_path), showWarnings = FALSE, recursive = TRUE)
    if (as_sparse) {
        saveSparse(
            LD_matrix = LD_matrix,
            LD_path = RDS_path,
            verbose = FALSE
        )
    } else {
        saveRDS(LD_matrix,
            file = RDS_path
        )
    }
    return(list(
        LD = LD_matrix,
        DT = dat,
        RDS_path = RDS_path
    ))
}
