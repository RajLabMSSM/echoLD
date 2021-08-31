#' Compute LD from 1000 Genomes
#'
#' Downloads a subset vcf of the 1KG database that matches
#'  your locus coordinates. Then uses \link[snpStats]{ld}
#'   to calculate LD on the fly.
#'
#' This approach is taken, because other API query tools have
#' limitations with the window size being queried.
#' This approach does not have this limitations,
#' allowing you to fine-map loci more completely.
#'
#' @param fillNA When pairwise LD (r) between two SNPs is \code{NA},
#' replace with 0.
#' @inheritParams load_or_create
#' @inheritParams echotabix::query_vcf
#'
#' @examples
#' \dontrun{
#' data("BST1")
#' data("locus_dir")
#' locus_dir <- file.path(tempdir(), locus_dir)
#' dat <- BST1[seq(1, 50), ]
#' LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
#'     package = "echoLD"
#' )
#' LD_list <- LD_custom(
#'     locus_dir = locus_dir,
#'     dat = dat,
#'     LD_reference = LD_reference
#' )
#' }
#' @family LD
#' @keywords internal
#' @importFrom echotabix query_vcf
LD_custom <- function(locus_dir = tempdir(),
                      dat,
                      LD_reference,
                      ref_genome = "GRCh37",
                      superpopulation = NULL,
                      samples = NULL,
                      local_storage = NULL,
                      leadSNP_LD_block = FALSE,
                      force_new_vcf = FALSE,
                      force_new_MAF = FALSE,
                      fillNA = 0,
                      stats = "R",
                      # min_r2=F,
                      # min_Dprime=F,
                      # remove_correlates = FALSE,
                      verbose = TRUE) {
    messager("echoLD:: Using custom VCF as LD reference panel.", v = verbose)
    locus <- basename(locus_dir)
    vcf_url <- LD_reference
    #### Query ####
    vcf <- echotabix::query_vcf(
        dat = dat,
        vcf_url = vcf_url,
        locus_dir = locus_dir,
        vcf_name = LD_reference,
        ref_genome = ref_genome,
        samples = samples,
        force_new_vcf = force_new_vcf,
        verbose = verbose
    )
    #### Convert to snpStats object ####
    ss <- VariantAnnotation::genotypeToSnpMatrix(
        x = vcf,
        select.snps = dat$SNP
    )
    #### Get MAF (if needed) ####
    dat <- snpstats_get_MAF(
        dat = dat,
        ss = ss,
        force_new_MAF = force_new_MAF,
        verbose = verbose
    )
    #### Filter out SNPs not in the same LD block as the lead SNP ####
    if (leadSNP_LD_block) {
        dat_LD <- get_leadsnp_block(
            dat = dat,
            ss = ss,
            verbose = verbose
        )
        dat <- dat_LD$dat
        LD_r2 <- dat_LD$LD_r2
    }
    #### Get LD ####
    if (tolower(stats) %in% c("r.squared", "r2")) {
        # pre-computed during LD block clustering
        LD_matrix <- LD_r2
    } else {
        LD_matrix <- compute_LD(
            ss = ss,
            select_snps = dat$SNP,
            stats = stats,
            verbose = verbose
        )
    }
    #### Save LD matrix ####
    LD_list <- save_LD_matrix(
        LD_matrix = LD_matrix,
        dat = dat,
        locus_dir = locus_dir,
        subset_common = TRUE,
        fillNA = fillNA,
        LD_reference = LD_reference,
        verbose = verbose
    )
    return(LD_list)
}
