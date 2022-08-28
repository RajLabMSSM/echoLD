#' Procure an LD matrix for fine-mapping
#'
#' Calculate and/or query linkage disequilibrium (LD) from reference panels
#'  (UK Biobank, 1000 Genomes), a user-supplied pre-computed LD matrix.\cr\cr
#' \strong{Options}:\cr
#' \itemize{
#' \item{Download pre-computed LD matrix from UK Biobank.}
#' \item{Download raw VCF file from 1KG and compute LD on the fly.}
#' \item{Compute LD on the fly from a user-supplied VCF file.}
#' \item{Use a user-supplied pre-computed LD-matrix.}
#' }
#'
#' @param locus_dir Storage directory to use. 
#' @param query_dat SNP-level summary statistics subset 
#' to query the LD panel with.
#' @param force_new_LD If LD file exists, create a new one.
#' @param LD_reference LD reference to use:
#' \itemize{
#' \item{"1KGphase1" : }{1000 Genomes Project Phase 1}
#' \item{"1KGphase3" : }{1000 Genomes Project Phase 3}
#' \item{"UKB" : }{Pre-computed LD from a British
#' European-decent subset of UK Biobank.}
#' \item{"<vcf_path>" : }{User-supplied path to a custom VCF file 
#' to compute LD matrix from.}
#' }
#' @param query_genome Genome build of the \code{query_dat}.
#' @param target_genome Genome build of the LD panel.
#' @param superpopulation Superpopulation to subset LD panel by
#'  (used only if \code{LD_reference} is "1KGphase1" or "1KGphase3").
#'  See \link[echoLD]{popDat_1KGphase1} and \link[echoLD]{popDat_1KGphase3}
#'  for full tables of their respective samples. 
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
#' @param force_new_LD Force new LD subset.
#'
#' @inheritParams echotabix::query_vcf
#' @inheritParams downloadR::downloader
#' @inheritParams echodata::mungesumstats_to_echolocatoR
#'
#' @returns A named list containing:
#' \itemize{
#' \item{"LD": }{Symmetric LD matrix of pairwise SNP correlations.}
#' \item{"DT": }{Standardised query data filtered to only the 
#' SNPs included in both \code{query_dat} and the LD matrix.}
#' \item{"path": }{The path to where the LD matrix was saved.}
#' } 
#'
#' @family LD
#' @export
#' @importFrom echodata mungesumstats_to_echolocatoR
#' @examples
#' query_dat <- echodata::BST1[seq(1, 50), ] 
#' locus_dir <- file.path(tempdir(), echodata::locus_dir) 
#'
#' LD_list <- echoLD::get_LD(
#'     locus_dir = locus_dir,
#'     query_dat = query_dat,
#'     LD_reference = "1KGphase1")
get_LD <- function(query_dat,
                   locus_dir=tempdir(),
                   standardise_colnames = FALSE,
                   force_new_LD = FALSE,
                   LD_reference = c("1KGphase1", "1KGphase3", "UKB"),
                   query_genome = "hg19",
                   target_genome = "hg19",
                   samples = character(0),
                   superpopulation = NULL,
                   local_storage = NULL,
                   leadSNP_LD_block = FALSE,
                   fillNA = 0,
                   verbose = TRUE,
                   remove_tmps = TRUE,
                   as_sparse = TRUE,
                   download_method = "axel",
                   conda_env = "echoR_mini",
                   nThread = 1) {
    
    # echoverseTemplate:::source_all(); 
    # echoverseTemplate:::args2vars(get_LD)
    
    LD_reference <- LD_reference[1]
    RDS_path <- get_rds_path(
        locus_dir = locus_dir,
        LD_reference = LD_reference
    )
    #### Standardise colnames ####
    if(isTRUE(standardise_colnames)){
        query_dat <- echodata::mungesumstats_to_echolocatoR(
            dat = query_dat,
            standardise_colnames = TRUE,
            verbose = verbose)
    } 
    #### Import existing LD ####
    if (file.exists(RDS_path) & (isFALSE(force_new_LD))) {
        LD_list <- read_LD_list(RDS_path=RDS_path,
                                query_dat=query_dat,
                                verbose=verbose)
    } else if (tolower(LD_reference) == "ukb") {
        #### UK Biobank ####
        LD_list <- get_LD_UKB(
            query_dat = query_dat,
            query_genome = query_genome,
            locus_dir = locus_dir,
            force_new_LD = force_new_LD,
            local_storage = local_storage,
            download_method = download_method,
            fillNA = fillNA, 
            return_matrix = TRUE,
            as_sparse = as_sparse,
            conda_env = conda_env,
            remove_tmps = remove_tmps,
            nThread = nThread,
            verbose = verbose
        )
    } else if (tolower(LD_reference) %in% c("1kgphase1", "1kgphase3")) {
        #### 1000 Genomes ####
        LD_list <- get_LD_1KG(
            locus_dir = locus_dir,
            query_dat = query_dat,
            query_genome = query_genome,
            local_storage = local_storage,
            LD_reference = LD_reference,
            samples = samples,
            superpopulation = superpopulation,
            leadSNP_LD_block = leadSNP_LD_block,
            fillNA = fillNA,
            as_sparse = as_sparse,
            remove_tmps = remove_tmps,
            conda_env = conda_env,
            verbose = verbose
        )
    } else if (any(endsWith(
        tolower(LD_reference),
        c(".vcf", ".vcf.gz", ".vcf.bgz")
    ))) {
        #### Custom vcf ####
        LD_list <- get_LD_custom(
            locus_dir = locus_dir,
            query_dat = query_dat,
            local_storage = local_storage,
            LD_reference = LD_reference,
            target_genome = target_genome,
            samples = samples,
            superpopulation = superpopulation,
            leadSNP_LD_block = leadSNP_LD_block,
            fillNA = fillNA,
            as_sparse = as_sparse,
            remove_tmps = remove_tmps,
            conda_env = conda_env,
            verbose = verbose
        )
    } else {
        msg <- paste0(
            "LD_reference input not recognized.", 
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

load_or_create <- function(...){
    .Deprecated("get_LD")
    get_LD(...)
}
