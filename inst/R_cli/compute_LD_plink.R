#' Calculate LD
#'
#' Calculate a pairwise LD matrix from a vcf file using \emph{plink}.
#' @param locus_dir Locus-specific results directory.
#' @param ld_window Set --r/--r2 max variant ct pairwise distance (usu. 10).
#' @param ld_format Whether to produce an LD matrix with
#' r (\code{ld_format="r"}) or D' (\code{ld_format="D"}) as the
#' pairwise SNP correlation metric.
#' @family LD
#' @keywords internal
calculate_LD <- function(locus_dir,
                         ld_window = 1000, # 10000000
                         ld_format = "r",
                         plink_prefix = "plink",
                         conda_env = "echoR",
                         verbose = TRUE) {
    
    plink <- echoconda::find_packages(packages = "plink", 
                                      conda_env = conda_env,
                                      verbose = verbose) 
    messager("LD:PLINK:: Calculating LD ( r & D'-signed; LD-window =", ld_window, ")", v = verbose)
    plink_path_prefix <- file.path(locus_dir, "LD", plink_prefix)
    dir.create(file.path(locus_dir, "LD"), recursive = TRUE, showWarnings = FALSE)
    out_prefix <- paste0(plink_path_prefix, ".r_dprimeSigned")
    if (ld_format == "r") {
        cmd <- paste(
            plink,
            "--bfile", plink_path_prefix,
            "--r square bin",
            "--out", out_prefix
        )
        ld.path <- paste0(out_prefix, ".ld.bin")
    } else {
        cmd <- paste(
            plink,
            "--bfile", plink_path_prefix,
            "--r dprime-signed",
            "--ld-window", ld_window,
            "--ld-window-kb", ld_window,
            "--out", out_prefix
        )
        ld.path <- paste0(out_prefix, ".ld")
    }
    system(cmd)
    return(ld.path)
}
