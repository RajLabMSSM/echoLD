#' Calculate LD (r or r2)
#'
#' This appriach computes and LD matrix of r or r2 (instead of D') from a vcf.
#' See \code{dprime_table} for a slower (but more flexible) alternative to computing LD.
#' @param bim A bim file produced by \emph{plink}
#' @param LD_folder Locus-specific LD output folder.
#' @param r_format Whether to fill the matrix with \code{r} or \code{r2}.
#' @family LD
#' @keywords internal
run_plink_LD <- function(bim,
                         LD_folder = file.path(tempdir(), "LD"),
                         plink_prefix = "plink",
                         r_format = "r",
                         extract_file = NULL,
                         conda_env = "echoR_mini") {
    plink <- plink_file(conda_env = conda_env)
    # METHOD 2 (faster, but less control over parameters.
    # Most importantly, can't get Dprime)
    system(paste(
        plink,
        "--bfile", file.path(LD_folder, plink_prefix),
        if (is.null(extract_file)) NULL else "--extract", extract_file,
        paste0("--", r_format, " square bin"),
        "--out", file.path(LD_folder, plink_prefix)
    ))
    ld.bin <- file.path(LD_folder, paste0(plink_prefix, ".ld.bin"))
    bin.vector <- readBin(ld.bin, what = "numeric", n = length(bim$SNP)^2)
    ld.matrix <- matrix(bin.vector,
        nrow = length(bim$SNP),
        dimnames = list(bim$SNP, bim$SNP)
    )
    return(ld.matrix)
}
