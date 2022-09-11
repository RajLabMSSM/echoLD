#' Read LD matrix
#' 
#' Read in an LD matrix stored in a variety of file formats, and convert it
#' to a sprase matrix.
#' @param LD_path Path to LD matrix.
#' @param as_df Convert to the matrix to a \link[base]{data.frame}.
#' @inheritParams get_LD 
#' @inheritDotParams downloadR::load_rdata
#' 
#' @export
#' @importFrom downloadR load_rdata
#' @importFrom data.table fread
#' @importFrom Matrix readMM
#' @examples
#' LD_path <- tempfile(fileext = ".csv")
#' utils::write.csv(echodata::BST1_LD_matrix,
#'                  file = LD_path,
#'                  row.names = TRUE)
#' ld_mat <- readSparse(LD_path = LD_path)
readSparse <- function(LD_path,
                       as_sparse = TRUE,
                       as_df = FALSE,
                       verbose = TRUE,
                       ...) {
    
    LD_ref_type <- LD_reference_options(LD_reference = LD_path, 
                                        as_subgroups = TRUE)
    #### Read matrix ####
    if(LD_ref_type=="r"){
        ld_mat <- downloadR::load_rdata(fileName = LD_path,
                                        ...)
    } else if(LD_ref_type=="table"){
        ld_mat <- data.table::fread(LD_path)
        ld_mat <- as.matrix(ld_mat[,-1]) |> `rownames<-`(ld_mat[[1]])
    } else if(LD_ref_type=="Matrix Market"){
        msg <- paste(
            "WARNING:",
            "Matrix Market files (.mtx / .mtx.gz) do not have row/col names.",
            "Users must annotate the row/col names with RSIDS",
            "before using them in any echoverse functions.")
        message(msg)
        ld_mat <- Matrix::readMM(file = LD_path)
    }
    #### Format matrix ####
    if (isTRUE(as_df)){
        ld_mat <- data.frame(as.matrix(ld_mat))
    } else if(isTRUE(as_sparse)){
        ld_mat <- to_sparse(X = ld_mat,
                            verbose = verbose)
    } 
    return(ld_mat)
}
