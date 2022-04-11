#' Calculate LD blocks.
#'
#' Uses \emph{plink} to group highly correlated SNPs into LD blocks.
#'
#' @param LD_folder Path to save LD to.
#' @param LD_block_size Block size. Passed to
#' "--blocks-inform-frac" argument in \code{plink}.
#' Recommended default value is \code{0.7}.
#' @inheritParams echoconda::find_package
#'
#' @family LD
#' @keywords internal
#' @importFrom data.table fread
LD_blocks_cli <- function(bed_bim_fam,
                          LD_block_size = .7,
                          conda_env = "echoR",
                          verbose = TRUE) {
    # Avoid confusing checks
    LD_folder <- NULL

    messager("++ Calculating LD blocks...",
        v = verbose
    )
    # PLINK 1.07 LD: http://zzz.bwh.harvard.edu/plink/ld.shtml
    # PLINK 1.9 LD: https://www.cog-genomics.org/plink/1.9/ld
    # system("plink", "-h")
    # Identify duplicate snps
    # system("plink", "--vcf subset.vcf --list-duplicate-vars")
    # Convert vcf to plink format
    # system("plink", "--vcf subset.vcf --exclude ./plink_tmp/plink.dupvar
    # --make-bed --out PTK2B")

    # Estimate LD blocks
    # Defaults: --blocks-strong-lowci = 0.70, --blocks-strong-highci .90

    # Reducing "--blocks-inform-frac" is the only parameter that seems
    # to make the block sizes larger
    dir.create(LD_folder, showWarnings = FALSE, recursive = TRUE)
    plink <- echoconda::find_packages(packages = "plink", 
                                      conda_env = conda_env,
                                      verbose = verbose)
    system(paste(
        plink, "--bfile", dirname(bed_bim_fam$bim),
        "--blocks no-pheno-req no-small-max-span --blocks-max-kb 100000",
        # "--blocks-strong-lowci .52 --blocks-strong-highci 1",
        "--blocks-inform-frac", LD_block_size, " --blocks-min-maf 0",
        "--out", dirname(bed_bim_fam$bim)
    ))
    # system( paste("plink", "--bfile plink --ld-snp-list snp_list.txt --r") )
    blocks <- data.table::fread("./plink_tmp/plink.blocks.det")
    return(blocks)
}
