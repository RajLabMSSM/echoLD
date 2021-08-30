#' Plot a subset of the LD matrix
#'
#' Uses \code{gaston} to plot a SNP-annotated LD matrix.
#' @inheritParams echolocatoR::finemap_pipeline
#' @family LD
#' @keywords internal
#' @param span This is very computationally intensive,
#' so you need to limit the number of SNPs with span.
#' If \code{span=10}, only 10 SNPs upstream and 10 SNPs downstream of the lead SNP will be plotted.
#' @examples
#' \dontrun{
#' data("BST1")
#' data("BST1_LD")
#' plot_LD(LD_matrix = LD_matrix, dat = BST1)
#' }
#' @importFrom gaston LD.plot
#' @importFrom stats heatmap
#' @importFrom graphics image
plot_LD <- function(LD_matrix,
                    dat,
                    span = 10,
                    method = c("gaston", "heatmap", "image")) {
    # Avoid confusing checks
    SNP <- NULL

    leadSNP <- subset(dat, leadSNP)$SNP
    lead_index <- match(leadSNP, rownames(LD_matrix))

    start_pos <- lead_index - min(span, dim(LD_matrix)[1], na.rm = TRUE)
    end_pos <- lead_index + min(span, dim(LD_matrix)[1], na.rm = TRUE)
    sub_DT <- subset(dat, SNP %in% rownames(LD_matrix))

    if (method[1] == "gaston") {
        gaston::LD.plot(
            LD = LD_matrix[
                seq(start_pos, end_pos),
                seq(start_pos, end_pos)
            ],
            snp.positions = sub_DT$POS[seq(start_pos, end_pos)]
        )
    }
    if (method[1] == "heatmap") {
        stats::heatmap(as.matrix(LD_matrix)[
            seq(start_pos, end_pos),
            seq(start_pos, end_pos)
        ])
    }
    if (method[1] == "image") {
        graphics::image(as.matrix(LD_matrix)[
            seq(start_pos, end_pos),
            seq(start_pos, end_pos)
        ])
    }
}