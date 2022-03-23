#' Plot a subset of the LD matrix
#'
#' Plot a heatmap of pairwise LD between SNPs.
#' 
#' @param LD_matrix LD matrix.
#' @param span This is very computationally intensive,
#' so you need to limit the number of SNPs with span.
#' If \code{span=10}, only 10 SNPs upstream and 10 SNPs downstream of the
#'  lead SNP will be plotted.
#' @param method Method to use for plotting:
#' \itemize{
#' \item{"stats" : }\link[stats]{heatmap}
#' \item{"gaston" : }\link[gaston]{LD.plot}
#' \item{"graphics" : }\link[graphics]{image}
#' }
#' @param ... Additional arguments passed to plotting function. 
#' @inheritParams get_LD
#' @family LD
#' 
#' @export
#' @importFrom stats heatmap
#' @examples
#'query_dat<- echodata::BST1
#' LD_matrix <- echodata::BST1_LD_matrix
#' echoLD::plot_LD(LD_matrix = LD_matrix,query_dat= query_dat)  
plot_LD <- function(LD_matrix,
                    query_dat,
                    span = 10,
                    method = c("stats","gaston","graphics"),
                    ...) {
    # Avoid confusing checks
    SNP <- NULL; 
    
    method <- tolower(method[1])
    leadSNP <- subset(query_dat, leadSNP)$SNP
    lead_index <- match(leadSNP, rownames(LD_matrix))

    start_pos <- lead_index - min(span, dim(LD_matrix)[1], na.rm = TRUE)
    start_pos <- max(start_pos, 0)
    end_pos <- lead_index + min(span, dim(LD_matrix)[1], na.rm = TRUE)
    sub_query_dat <- subset(query_dat, SNP %in% rownames(LD_matrix))

    if (method[1] == "gaston") {
        requireNamespace("gaston")
        gaston::LD.plot(
            LD = LD_matrix[
                seq(start_pos, end_pos),
                seq(start_pos, end_pos)
            ],
            snp.positions = sub_query_dat$POS[seq(start_pos, end_pos)],
            ...
        )
    } else if (method[1] == "graphics") {
        requireNamespace("graphics")
        graphics::image(as.matrix(LD_matrix)[
            seq(start_pos, end_pos),
            seq(start_pos, end_pos)
        ],
        ...)
    } else { 
        stats::heatmap(as.matrix(LD_matrix)[
            seq(start_pos, end_pos),
            seq(start_pos, end_pos)
        ],
        Colv=FALSE,
        Rowv=FALSE,
        ...
        ) 
    }
}
