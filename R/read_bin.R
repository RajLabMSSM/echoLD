#' Create LD matrix from plink output
#'
#' Depending on which parameters you give \emph{plink} when calculating LD, you get different file outputs.
#' When it produces bin and bim files, use this function to create a proper LD matrix.
#' For example, this happens when you try to calculate D' with the \code{--r dprime-signed} flag (instead of just r).
#' @param LD_dir Directory that contains the bin/bim files.
#' @family LD
#' @keywords internal
#' @examples
#' \dontrun{
#' locus_dir <- "/sc/arion/projects/pd-omics/brian/Fine_Mapping/Data/QTL/Microglia_all_regions/BIN1"
#' ld.matrix <- read_bin(LD_dir = file.path(locus_dir, "LD"))
#' }
#'
read_bin <- function(LD_dir) {
    bim <- data.table::fread(file.path(LD_dir, "plink.bim"),
        col.names = c("CHR", "SNP", "V3", "POS", "A1", "A2")
    )
    bin.vector <- readBin(file.path(LD_dir, "plink.ld.bin"),
        what = "numeric",
        n = length(bim$SNP)^2
    )
    ld.matrix <- matrix(bin.vector,
        nrow = length(bim$SNP),
        dimnames = list(bim$SNP, bim$SNP)
    )
    return(ld.matrix)
}
