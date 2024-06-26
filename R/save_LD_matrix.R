#' Save LD matrix
#'
#' Save an LD matrix after initial pre-processing.
#' @source 
#' \code{
#' dat <- echodata::BST1
#' LD_matrix <- echodata::BST1_LD_matrix 
#' locus_dir <- file.path(tempdir(),echodata::locus_dir)
#' 
#' LD_list <- echoLD:::save_LD_matrix(
#'     LD_matrix = LD_matrix,
#'     dat = dat
#'     locus_dir = locus_dir,
#'     LD_reference = "UKB")
#' LD_list <- echoLD:::save_LD_matrix(
#'     LD_matrix = LD_matrix,
#'     dat = dat
#'     locus_dir = locus_dir,
#'     LD_reference = "custom_vcf")
#' }
#' @inheritParams get_LD
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
    
    if (isTRUE(subset_common)) {
        sub.out <- subset_common_snps(
            LD_matrix = LD_matrix,
            fillNA = fillNA,
            dat = dat,
            as_sparse = as_sparse,
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
    if (isTRUE(as_sparse)) {
        saveSparse(
            LD_matrix = LD_matrix,
            LD_path = RDS_path,
            verbose = verbose
        )
    } else {
        messager("Saving dense LD matrix ==>", RDS_path, v = verbose)
        saveRDS(object = LD_matrix,
                file = RDS_path
        )
    }
    return(list(
        LD = LD_matrix,
        DT = dat,
        path = RDS_path
    ))
}
