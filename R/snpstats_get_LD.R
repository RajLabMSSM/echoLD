#' Get LD using \pkg{snpStats} package
#'
#' @param LD_folder Locus-specific LD output folder.
#' @inheritParams snpStats::ld
#' @family LD
#' @keywords internal
#' @source
#' \href{https://www.bioconductor.org/packages/release/bioc/html/snpStats.html}{snpStats Bioconductor page}
#' \href{https://www.bioconductor.org/packages/release/bioc/vignettes/snpStats/inst/doc/ld-vignette.pdf}{LD tutorial}
#' @importFrom snpStats read.plink ld
snpstats_get_LD <- function(bed_bim_fam,
                            select_snps = NULL,
                            stats = c("R"),
                            symmetric = TRUE,
                            depth = "max",
                            nThread = 1,
                            verbose = TRUE) {
    messager("LD:snpStats:: Computing LD",
        paste0("(stats = ", paste(stats, collapse = ", "), ")"),
        v = verbose
    )
    # dir.create(LD_folder, showWarnings = FALSE, recursive = TRUE)
    # select_snps= arg needed bc otherwise read.plink() sometimes complains of
    ## duplicate RSID rownames. Also need to check whether these
    # SNPs exist in the plink files.
    ## (snpStats doesn't have very good error handling for these cases).
    select_snps <- snpstats_ensure_nonduplicates(
        select_snps = select_snps,
        bim_path = bed_bim_fam$bim,
        nThread = nThread,
        verbose = verbose
    )
    # Only need to give bed path (infers bin/fam paths)
    ss <- snpStats::read.plink(
        bed = bed_bim_fam$bed,
        select.snps = select_snps
    )
    # Compute LD from snpMatrix
    ld_list <- snpStats::ld(
        x = ss$genotypes,
        y = ss$genotypes,
        depth = if (depth == "max") ncol(ss$genotypes) else depth,
        stats = stats,
        symmetric = symmetric
    )
    if (length(stats) == 1) {
        return(ld_list)
    } else {
        return(ld_list$R)
    }
}
