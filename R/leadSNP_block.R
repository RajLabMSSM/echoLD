#' Identify the LD block in which the lead SNP resides
#' @family LD
#' @keywords internal
leadSNP_block <- function(leadSNP,
                          LD_folder,
                          LD_block_size = .7) {
    messager("Returning lead SNP's block...")
    blocks <- LD_blocks(LD_folder, LD_block_size)
    splitLists <- strsplit(blocks$SNPS, split = "[|]")
    block_snps <- lapply(splitLists,
        function(l, leadSNP) {
            if (leadSNP %in% l) {
                return(l)
            }
        },
        leadSNP = leadSNP
    ) %>% unlist()
    messager("Number of SNPs in LD block =", length(block_snps))
    return(block_snps)
}
