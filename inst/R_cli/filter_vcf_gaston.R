#' #' Subset a VCF file by superpopulation
#' #'
#' #' @inheritParams filter_vcf_cli
#' #' @family LD
#' #' @keywords internal
#' #' @importFrom gaston read.vcf select.snps write.bed.matrix select.inds
#' filter_vcf_gaston <- function(vcf_subset,
#'                               query_dat
#'                               locus_dir,
#'                               superpopulation,
#'                               popDat,
#'                               verbose = TRUE) {
#'     # Avoid confusing checks
#'     id <- superpop <- NULL
#' 
#'     # Import w/ gaston and further subset
#'     messager("+ Importing VCF as bed file...", v = verbose)
#'     bed.file <- gaston::read.vcf(vcf_subset, verbose = F)
#'     ## Subset rsIDs
#'     bed <- gaston::select.snps(bed.file, id %in% dat$SNP & id != ".")
#'     # Create plink sub-dir
#'     dir.create(file.path(locus_dir, "LD"), recursive = T, showWarnings = FALSE)
#'     gaston::write.bed.matrix(bed, file.path(locus_dir, "LD/plink"), rds = NULL)
#'     # Subset Individuals
#'     selectedInds <- subset(popDat, superpop == superpopulation)
#'     bed <- gaston::select.inds(bed, id %in% selectedInds$sample)
#'     # Cleanup extra files
#'     remove(bed.file)
#'     # file.remove("vcf_subset")
#'     return(bed)
#' }
