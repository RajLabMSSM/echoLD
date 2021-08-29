#' Convert data.table to GRanges object
#'
#' @keywords internal
#' @importFrom GenomicRanges makeGRangesFromDataFrame
#' @importFrom GenomeInfoDb seqlevelsStyle
dt_to_granges <- function(dat,
                          style = "NCBI",
                          chrom_col = "CHR",
                          position_col = "POS") {
    dat[["SEQnames"]] <- dat[[chrom_col]]
    gr.snp <- GenomicRanges::makeGRangesFromDataFrame(dat,
        seqnames.field = "SEQnames",
        start.field = "POS",
        end.field = "POS"
    )
    suppressMessages(suppressWarnings(
        GenomeInfoDb::seqlevelsStyle(gr.snp) <- style
    ))
    return(gr.snp)
}
