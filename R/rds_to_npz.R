#' Convert .RDS file back to .npz format
#'
#' @family LD
#' @keywords internal
#' @importFrom reticulate use_condaenv import
rds_to_npz <- function(rds_path,
                       conda_env = "echoR_mini",
                       verbose = TRUE) {
    messager("POLYFUN:: Converting LD .RDS to .npz:", rds_path, v = verbose)
    LD_matrix <- readRDS(rds_path)
    reticulate::use_condaenv(condaenv = conda_env)
    np <- reticulate::import(module = "numpy")
    npz_path <- gsub(".RDS", ".npz", rds_path)
    np$savez(npz_path, as.matrix(LD_matrix))
    return(npz_path)
}
