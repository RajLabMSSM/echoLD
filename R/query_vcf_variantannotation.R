#' Query VCF
#'
#' # Alternative methods
#' \code{
#'  #### Rsamtools ####
#'  tab <- Rsamtools::scanTabix(file = vcf_url, gr)
#'  #### Rtracklayer ####
#'  tab <- Rsamtools::TabixFile(vcf_url)
#'  open(tab)
#'  tab <- rtracklayer::import(tab, which=gr)
#'  #### seqminer ####
#'  tab <- seqminer::tabix.read(tabixFile = vcf_url,
#'                               tabixRange = coord_range)
#'  header <- VariantAnnotation::scanVcfHeader(file = path)
#' }
#' @inheritParams VariantAnnotation::readVcf
#' @inheritParams query_vcf
#'
#' @source \href{https://bioconductor.org/packages/devel/bioc/vignettes/TVTB/inst/doc/VcfFilterRules.html}{
#' VariantAnnotation filtering}
#'
#' @examples
#' \dontrun{
#' data("BST1")
#' dat <- BST1[seq(1, 50), ]
#' vcf_url <- file.path(
#'     "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/",
#'     "ALL.chr4.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz"
#' )
#' vcf <- query_vcf_variantannotation(
#'     vcf_url = vcf_url,
#'     dat = dat
#' )
#' }
#'
#' @keywords internal
#' @importFrom GenomicRanges GRanges
#' @importFrom VariantAnnotation ScanVcfParam readVcf writeVcf
#' @importFrom Rsamtools TabixFile
#' @importFrom IRanges IRanges
query_vcf_variantannotation <- function(vcf_url,
                                        dat,
                                        samples = character(),
                                        genome = "GRCh37",
                                        save_path = tempfile(
                                            fileext = ".vcf.bgz"
                                        ),
                                        verbose = TRUE) {
    # https://github.com/MRCIEU/gwasvcf/blob/0c48479836dd16b3f27280b87a3ded41e6034a17/R/query.r#L180
    messager("LD:: Querying VCF file.", v = verbose)
    startQ <- Sys.time()
    chrompos <- paste0(dat$CHR[1], ":", min(dat$POS), "-", max(dat$POS))
    gr2 <- GenomicRanges::GRanges(
        seqnames = dat$CHR[1],
        ranges = IRanges::IRanges(
            start = min(dat$POS),
            end = max(dat$POS)
        )
    )
    if (is.null(samples)) samples <- character()
    # Rsamtools::headerTabix(vcf_url)$seqnames

    param <- VariantAnnotation::ScanVcfParam(
        samples = samples,
        which = gr2
    )
    tab <- Rsamtools::TabixFile(vcf_url)
    vcf <- VariantAnnotation::readVcf(
        file = tab,
        genome = genome,
        param = param
    )
    # snp_summary <- VariantAnnotation::snpSummary(vcf)
    # snp_info <- info(vcf)

    common_snps <- intersect(dat$SNP, rownames(vcf))
    message("Removing non-overlapping SNPs.")
    vcf_filt <- vcf[common_snps, ]

    report_time(start = startQ, v=verbose) 
    if (!is.null(save_path)) {
        messager("Saving VCF subset ==>", save_path, v = verbose)
        dir.create(dirname(save_path), showWarnings = FALSE, recursive = TRUE)
        VariantAnnotation::writeVcf(
            obj = vcf_filt,
            # Otherwise will name the file "...bgz.bgz"
            filename = gsub(".bgz|.gz", "", save_path),
            index = TRUE
        )
    }
    return(vcf_filt)
}
