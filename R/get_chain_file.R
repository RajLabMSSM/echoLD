#' Download chain file for liftover
#'
#' @source \href{https://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/}{
#' UCSC chain files}
#' @keywords internal
#' @importFrom utils download.file
#' @importFrom R.utils gunzip
#' @importFrom rtracklayer import.chain
get_chain_file <- function(build_conversion = c(
                               "hg38ToHg19",
                               "hg19ToHg38"
                           ),
                           save_dir = tempdir(),
                           verbose = TRUE) {

    #### Define paths ####
    remote_path <- file.path(
        "ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/liftOver",
        paste0(build_conversion[1], ".over.chain.gz")
    )
    local_path <- file.path(save_dir, basename(remote_path))
    local_path_gunzip <- gsub(".gz", "", local_path)
    ### Download chain file ####
    if (file.exists(local_path_gunzip)) {
        messager("Using existing chain file.", v = verbose)
    } else {
        messager("Downloading chain file from UCSC Genome Browser.", v = verbose)
        utils::download.file(remote_path, local_path)
        R.utils::gunzip(local_path)
    }
    #### Import ####
    chain <- rtracklayer::import.chain(local_path_gunzip)
    return(chain)
}
