#' Identify the LD block in which the lead SNP resides
#'
#' @inheritParams LD_blocks
#' @inheritParams echoconda::find_package
#'
#' @family LD
#' @keywords internal
leadsnp_block_plink <- function(leadSNP,
                                bed_bim_fam,
                                LD_block_size = .7,
                                verbose = TRUE,
                                conda_env = "echoR") {
    messager("Returning lead SNP's block...")
    blocks <- LD_blocks_plink(
        bed_bim_fam = bed_bim_fam,
        LD_block_size = LD_block_size,
        conda_env = conda_env,
        verbose = verbose
    )
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
