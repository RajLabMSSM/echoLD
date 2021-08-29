#' Subset a vcf by superpopulation
#'
#' @inheritParams filter_vcf
#' @family LD
#' @keywords internal
filter_vcf_gaston <- function(vcf_subset,
                              dat,
                              locus_dir,
                              superpopulation,
                              popDat,
                              verbose = TRUE) {
    # Import w/ gaston and further subset
    messager("+ Importing VCF as bed file...", v = verbose)
    bed.file <- gaston::read.vcf(vcf_subset, verbose = F)
    ## Subset rsIDs
    bed <- gaston::select.snps(bed.file, id %in% dat$SNP & id != ".")
    # Create plink sub-dir
    dir.create(file.path(locus_dir, "LD"), recursive = T, showWarnings = FALSE)
    gaston::write.bed.matrix(bed, file.path(locus_dir, "LD/plink"), rds = NULL)
    # Subset Individuals
    selectedInds <- subset(popDat, superpop == superpopulation)
    bed <- gaston::select.inds(bed, id %in% selectedInds$sample)
    # Cleanup extra files
    remove(bed.file)
    # file.remove("vcf_subset")
    return(bed)
}
