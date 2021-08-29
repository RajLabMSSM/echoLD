#' Create LD matrix from plink output.
#'
#' Depending on which parameters you give \emph{plink} when calculating LD, you get different file outputs.
#' When it produces an LD table, use this function to create a proper LD matrix.
#' @family LD
#' @keywords internal
#' @importFrom data.table fread dcast.data.table data.table
#' @importFrom dplyr %>%
read_ld_table <- function(ld.path,
                          snp.subset = FALSE,
                          fillNA = 0,
                          verbose = T) {
    # dat <- data.table::fread(file.path(locus_dir,"Multi-finemap/Multi-finemap_results.txt")); snp.subset <- dat$SNP
    ld.table <- data.table::fread(ld.path, nThread = 4)
    if (any(snp.subset != F)) {
        messager("LD:PLINK:: Subsetting LD data...", v = verbose)
        ld.table <- subset(ld.table, SNP_A %in% snp.subset | SNP_B %in% snp.subset)
    }
    messager("LD:PLINK:: Casting data.matrix...", v = verbose)
    ld.cast <- data.table::dcast.data.table(ld.table,
        formula = SNP_B ~ SNP_A,
        value.var = "R",
        fill = 0,
        drop = T,
        fun.agg = function(x) {
            mean(x, na.rm = T)
        }
    )
    ld.cast <- subset(ld.cast, SNP_B != ".", select = -`.`)
    ld.mat <- data.frame(ld.cast, row.names = ld.cast$SNP_B) %>%
        data.table() %>%
        as.matrix()
    # ld.mat[1:10,1:10]
    ld.mat <- fill_NA(
        LD_matrix = ld.mat,
        fillNA = fillNA,
        verbose = verbose
    )
    return(ld.mat)
}
