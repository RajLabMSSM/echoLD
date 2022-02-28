#' Procure an LD matrix for fine-mapping
#'
#' Calculate and/or query linkage disequilibrium (LD) from reference panels
#'  (UK Biobank, 1000 Genomes), a user-supplied pre-computed LD matrix
#'
#' Options:
#' \itemize{
#' \item{Download pre-computed LD matrix from UK Biobank.}
#' \item{Download raw VCF file from 1KG and compute LD on the fly.}
#' \item{Compute LD on the fly from a user-supplied VCF file.}
#' \item{Use a user-supplied pre-computed LD-matrix.}
#' }
#'
#' @param locus_dir Storage directory to use.
#' @param dat GWAS summary statistics subset to query the LD panel with.
#' @param force_new_LD If LD file exists, create a new one.
#' @param LD_reference LD reference to use:
#' \itemize{
#' \item{"1KGphase1" : }{1000 Genomes Project Phase 1}
#' \item{"1KGphase3" : }{1000 Genomes Project Phase 3}
#' \item{"UKB" : }{Pre-computed LD from a British
#' European-decent subset of UK Biobank.}
#' }
#' @param ref_genome Genome build of the LD panel
#' (used only if providing custom LD panel).
#' @param superpopulation Superpopulation to subset LD panel by
#'  (used only if \code{LD_reference} is "1KGphase1" or "1KGphase3".)
#' @param local_storage Storage folder for previously downloaded LD files.
#' If \code{LD_reference} is "1KGphase1" or "1KGphase3",
#' \code{local_storage} is where VCF files are stored.
#' If \code{LD_reference} is "UKB", \code{local_storage} is where
#' LD compressed numpy array (npz) files are stored.
#' Set to \code{NULL} to download VCFs/LD npz from remote storage system.
#' @param fillNA Value to fill LD matrix NAs with.
#' @param remove_tmps Remove all intermediate files
#' like VCF, npz, and plink files.
#' @param as_sparse Convert the LD matrix to a sparse matrix.
#' @param leadSNP_LD_block Only return SNPs within the same LD block
#' as the lead SNP (the SNP with the smallest p-value).
#'
#' @inheritParams echotabix::query_vcf
#' @inheritParams downloadR::downloader
#'
#' @return A symmetric LD matrix of pairwise SNP correlations.
#'
#' @family LD
#' @examples
#' BST1 <- echodata::BST1 
#' locus_dir <- file.path(tempdir(), echodata::locus_dir)
#' BST1 <- BST1[seq(1, 50), ] 
#' LD_list <- echoLD::load_or_create(
#'     locus_dir = locus_dir,
#'     dat = BST1,
#'     LD_reference = "1KGphase1"
#' ) 
#' @export
load_or_create <- function(locus_dir,
                           dat,
                           force_new_LD = FALSE,
                           LD_reference = c("1KGphase1", "1KGphase3", "UKB"),
                           ref_genome = "hg19",
                           samples = NULL,
                           superpopulation = NULL,
                           local_storage = NULL,
                           leadSNP_LD_block = FALSE,
                           fillNA = 0,
                           verbose = TRUE,
                           remove_tmps = TRUE,
                           as_sparse = TRUE,
                           download_method = "axel",
                           # conda_env = "echoR",
                           nThread = 1) {
    LD_reference <- LD_reference[1]
    RDS_path <- get_rds_path(
        locus_dir = locus_dir,
        LD_reference = LD_reference
    )

    if (file.exists(RDS_path) & (!force_new_LD)) {
        #### Import existing LD ####
        messager("+  LD:: Previously computed LD_matrix detected.",
            "Importing...", RDS_path,
            v = verbose
        )
        LD_matrix <- readSparse(
            LD_path = RDS_path,
            convert_to_df = FALSE
        )
        LD_list <- list(
            DT = dat,
            LD = LD_matrix,
            RDS_path = RDS_path
        )
    } else if (tolower(LD_reference) == "ukb") {
        #### UK Biobank ####
        LD_list <- LD_ukbiobank(
            dat = dat,
            locus_dir = locus_dir,
            force_new_LD = force_new_LD,
            local_storage = local_storage,
            download_method = download_method,
            fillNA = fillNA,
            nThread = nThread,
            return_matrix = TRUE,
            as_sparse = as_sparse,
            # conda_env = conda_env,
            remove_tmps = remove_tmps
        )
    } else if (tolower(LD_reference) %in% c("1kgphase1", "1kgphase3")) {
        #### 1000 Genomes ####
        LD_list <- LD_1KG(
            locus_dir = locus_dir,
            dat = dat,
            local_storage = local_storage,
            LD_reference = LD_reference,
            samples = samples,
            superpopulation = superpopulation,
            leadSNP_LD_block = leadSNP_LD_block,
            fillNA = fillNA,
            as_sparse = as_sparse,
            verbose = verbose
        )
    } else if (any(endsWith(
        tolower(LD_reference),
        c(".vcf", ".vcf.gz", ".vcf.bgz")
    ))) {
        #### Custom vcf ####
        LD_list <- LD_custom(
            locus_dir = locus_dir,
            dat = dat,
            local_storage = local_storage,
            LD_reference = LD_reference,
            ref_genome = ref_genome,
            samples = samples,
            superpopulation = superpopulation,
            leadSNP_LD_block = leadSNP_LD_block,
            fillNA = fillNA,
            verbose = verbose
        )
    } else {
        msg <- paste0(
            "echoLD:: LD_reference input not recognized.", 
            " Must both one of:\n",
            paste0(" - ",
                c(
                    "1KGphase1", "1KGphase3", "UKB",
                    "Path to VCF file: .vcf / .vcf.gz / .vcf.bgz",
                    "Path to LD file: .rds / .tsv.gz / .csv.gz / .mtx.gz"
                ),
                collapse = "\n"
            )
        )
        stop(msg)
    }
    return(LD_list)
}
