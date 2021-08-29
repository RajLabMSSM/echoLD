#' Convert .RDS file back to .npz format
#'
#' @family LD
#' @keywords internal
#' @examples
#' \dontrun{
#' data("BST1")
#' npz_path <- rds_to_npz(rds_path = "/Users/schilder/Desktop/Fine_Mapping/Data/GWAS/Nalls23andMe_2019/BST1/plink/UKB_LD.RDS")
#' }
rds_to_npz <- function(rds_path,
                       conda_env = "echoR",
                       verbose = T) {
    messager("POLYFUN:: Converting LD .RDS to .npz:", rds_file, v = verbose)
    LD_matrix <- readRDS(rds_path)
    reticulate::use_condaenv(condaenv = conda_env)
    np <- reticulate::import(module = "numpy")
    npz_path <- gsub(".RDS", ".npz", rds_path)
    np$savez(npz_path, as.matrix(LD_matrix))
    return(npz_path)
}
