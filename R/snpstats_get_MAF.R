#' Get MAF using \pkg{snpStats} package
#'
#' @param LD_folder Locus-specific LD output folder.
#' @inheritParams snpStats::ld
#' @family LD
#' @keywords internal
#' @source
#' \href{https://www.bioconductor.org/packages/release/bioc/html/snpStats.html}{snpStats Bioconductor page}
#' @importFrom snpStats read.plink col.summary
#' @importFrom data.table merge.data.table
snpstats_get_MAF <- function(dat,
                             bed_bim_fam,
                             force_new_MAF = FALSE,
                             nThread = 1,
                             verbose = TRUE) {
    # Avoid confusing checks
    MAF <- NULL

    if (!"MAF" %in% colnames(dat) | force_new_MAF) {
        messager("LD::snpStats:: Filling `MAF` column with MAF from LD panel.",
                 v = verbose)
        select.snps <- snpstats_ensure_nonduplicates(
            select_snps = dat$SNP,
            bim_path = bed_bim_fam$bim,
            nThread = nThread,
            verbose = FALSE)
        ss <- snpStats::read.plink(
            bed = bed_bim_fam$bed,
            select.snps = select.snps
        ) 
        MAF_df <- data.frame(
            SNP = row.names(snpStats::col.summary(ss$genotypes)),
            MAF = snpStats::col.summary(ss$genotypes)$MAF
        )
        if ("MAF" %in% colnames(dat)) dat <- subset(dat, select = -MAF)
        subset_merge <- data.table::merge.data.table(
            data.table::data.table(dat),
            data.table::data.table(MAF_df),
            by = "SNP"
        )
        return(subset_merge)
    } else {
        messager("LD::snpStats:: `MAF` column already present.", v = verbose)
        return(dat)
    }
}
