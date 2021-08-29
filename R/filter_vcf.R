#' Filter a vcf by min/max coordinates
#'
#' Uses \emph{bcftools} to filter a vcf by min/max genomic coordinates
#' (in basepairs).
#' @param vcf_subset Path to the locus subset vcf.
#' @param popDat The metadata file listing the superpopulation
#' to which each sample belongs.
#' @inheritParams echolocatoR::finemap_pipeline
#' @family LD
#' @keywords internal
filter_vcf <- function(vcf_subset,
                       popDat,
                       superpopulation,
                       remove_tmp = TRUE,
                       verbose = TRUE) {
    vcf.gz <- paste0(vcf_subset, ".gz")
    vcf.gz.subset <- gsub("_subset", "_samples_subset", vcf.gz)
    # Compress vcf
    if (!file.exists(vcf.gz)) {
        messager("LD:BCFTOOLS:: Compressing vcf file...", v = verbose)
        system(paste("bgzip -f", vcf_subset))
    }
    # Re-index vcf
    messager("LD:TABIX:: Re-indexing vcf.gz...", v = verbose)
    system(paste("tabix -f -p vcf", vcf.gz))
    # Subset samples
    selectedInds <- subset(popDat, superpop == superpopulation)$sample %>%
        unique()
    messager("LD:BCFTOOLS:: Subsetting vcf to only include",
        superpopulation, "individuals (", length(selectedInds), "/",
        length(popDat$sample %>% unique()), ").",
        v = verbose
    )
    cmd <- paste(
        "bcftools view -s", paste(selectedInds, collapse = ","),
        vcf.gz, "| bgzip > tmp && mv tmp", vcf.gz.subset
    )
    system(cmd)
    # Remove old vcf
    if (remove_tmp) {
        out <- suppressWarnings(file.remove(vcf_subset))
    }
    return(vcf.gz.subset)
}
