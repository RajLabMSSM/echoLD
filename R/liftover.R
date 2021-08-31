#' Genome build liftover
#'
#' Transfer genomic coordinates from one genome build to another.
#'
#' @source \href{https://doi.org/doi:10.18129/B9.bioc.liftOver}{liftOver}
#' @source \href{https://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/}{
#' UCSC chain files}
#'
#' @param dat SNP-level data table.
#' @param chrom_col Name of the chromosome column.
#' @param start_col Name of the start position column.
#' @param end_col Name of the end position column
#'  (can be same as \code{start_col} if all data is SNP-level).
#' @param build_conversion From which to which genome build
#' to lift over \code{dat}.
#' @param as_granges Return lifted \code{dat} as
#' \link[GenomicRanges]{GenomicRanges} object.
#' @param verbose Print messages.
#'
#' @examples
#' data("BST1")
#' dat_lifted <- liftover(dat = BST1, build_conversion = "hg19ToHg38")
#' @export
#' @importFrom rtracklayer liftOver
#' @importFrom data.table data.table
liftover <- function(dat,
                     chrom_col = "CHR",
                     start_col = "POS",
                     end_col = start_col,
                     build_conversion = c(
                         "hg38ToHg19",
                         "hg19ToHg38"
                     ),
                     # merged = TRUE,
                     as_granges = FALSE,
                     verbose = TRUE) {
    messager("Lifting genome build:", build_conversion, v = verbose)
    #### Convert to GRanges ####
    gr <- dt_to_granges(
        dat = dat,
        style = "UCSC",
        chrom_col = chrom_col,
        start_col = start_col,
        end_col = end_col
    )
    #### Specify chain file ####
    chain <- get_chain_file(
        build_conversion = build_conversion,
        verbose = verbose
    )
    #### Liftover ####
    gr_lifted <- unlist(rtracklayer::liftOver(
        x = gr,
        chain = chain
    ))
    if (as_granges) {
        return(gr_lifted)
    } else {
        return(data.table::data.table(data.frame(gr_lifted)))
    }
}
