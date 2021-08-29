#' Get LD using \pkg{snpStats} package
#'
#' @param LD_folder Locus-specific LD output folder.
#' @inheritParams snpStats::ld
#' @family LD
#' @keywords internal
#' @source
#' \href{https://www.bioconductor.org/packages/release/bioc/html/snpStats.html}{snpStats Bioconductor page}
#' \href{https://www.bioconductor.org/packages/release/bioc/vignettes/snpStats/inst/doc/ld-vignette.pdf}{LD tutorial}
#' @examples
#' dat <- data.table::fread("/pd-omics/brian/Fine_Mapping/Data/GWAS/Kunkle_2019/ABCA7/Multi-finemap/ABCA7.Kunkle_2019.1KGphase3_LD.Multi-finemap.tsv.gz")
#' LD_folder <- "/pd-omics/brian/Fine_Mapping/Data/GWAS/Kunkle_2019/ABCA7/LD"
#' LD_matrix <- snpstats_get_LD(LD_folder = LD_folder, select.snps = dat$SNP)
#' @importFrom snpStats read.plink ld
snpstats_get_LD <- function(LD_folder,
                            plink_prefix = "plink",
                            select.snps = NULL,
                            stats = c("R"),
                            symmetric = TRUE,
                            depth = "max",
                            nThread = 1,
                            verbose = TRUE) {
    messager("LD:snpStats:: Computing LD", paste0("(stats = ", paste(stats, collapse = ", "), ")"), v = verbose)
    # select.snps= arg needed bc otherwise read.plink() sometimes complains of
    ## duplicate RSID rownames. Also need to check whether these SNPs exist in the plink files.
    ## (snpStats doesn't have very good error handling for these cases).
    select.snps <- snpstats_ensure_nonduplicates(
        select.snps = select.snps,
        LD_folder = LD_folder,
        plink_prefix = plink_prefix,
        nThread = nThread,
        verbose = verbose
    )
    # Only need to give bed path (infers bin/fam paths)
    ss <- snpStats::read.plink(
        bed = file.path(LD_folder, plink_prefix),
        select.snps = select.snps
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
