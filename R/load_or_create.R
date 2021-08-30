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
#' @param LD_genome_build Genome build of the LD panel 
#' (used only if providing custom LD panel).
#' @param superpopulation Superpopulation to subset LD panel by
#'  (used only if \code{LD_reference} is "1KGphase1" or "1KGphase3".)
#' @param remote_LD Whether to pull the LD reference from remote repository, 
#' or locally stored files.
#' @param local_storage Storage folder for previously downloaded LD files.
#' If \code{LD_reference} is "1KGphase1" or "1KGphase3",
#' \code{local_storage} is where VCF files are stored.
#' If \code{LD_reference} is "UKB", \code{local_storage} is where 
#' LD compressed numpy array (npz) files are stored. 
#' Set to \code{NULL} to download VCFs/LD npz from remote storage system.
#' @param fillNA Value to fill LD matrix NAs with.
#' @param remove_tmps Remove all temporary files like VCF, npz, and plink files.
#' @param as_sparse Convert the LD matrix to a sparse matrix.
#' @inheritParams LD_blocks
#' @inheritParams downloadR::downloader
#' @inheritParams echoconda::find_package
#' 
#' @return A symmetric LD matrix of pairwise \emph{r} values.
#' 
#' @family LD
#' @examples 
#' data("BST1")
#' data("locus_dir")
#' locus_dir <- file.path(tempdir(), locus_dir)
#' BST1 <- BST1[seq(1, 50), ]
#'
#' #LD_matrix <- load_or_create(
#' #    locus_dir = locus_dir,
#' #    dat = BST1,
#' #    LD_reference = "1KGphase1"
#' #) 
#' @export
load_or_create <- function(locus_dir,
                           dat,
                           force_new_LD = FALSE,
                           LD_reference = c("1KGphase1","1KGphase3","UKB"),
                           LD_genome_build = "hg19",
                           superpopulation = "EUR",
                           remote_LD = TRUE,
                           download_method = "axel",
                           local_storage = NULL,
                           # min_r2=0, 
                           LD_block_size = NULL,
                           # min_Dprime=FALSE,
                           # remove_correlates = FALSE,
                           fillNA = 0,
                           verbose = TRUE,
                           remove_tmps = TRUE,
                           as_sparse = TRUE,
                           conda_env = "echoR",
                           nThread = 1) {
    
    LD_reference <- tolower(LD_reference[1])
    RDS_path <- get_rds_path(
        locus_dir = locus_dir,
        LD_reference = LD_reference
    )

    if (file.exists(RDS_path) & (!force_new_LD)) {
        #### Import existing LD ####
        messager("+  LD:: Previously computed LD_matrix detected.",
                 "Importing...", RDS_path, v = verbose
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
    } else if (LD_reference == "ukb") {
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
            as_sparse = TRUE,
            conda_env = conda_env,
            remove_tmps = remove_tmps
        )
    } else if (LD_reference == "1kgphase1" |
        LD_reference == "1kgphase3") {
        #### 1000 Genomes ####
        LD_list <- LD_1KG(
            locus_dir = locus_dir,
            dat = dat,
            vcf_folder = local_storage,
            LD_reference = LD_reference,
            superpopulation = superpopulation,
            remote_LD = remote_LD, 
            LD_block_size = LD_block_size,
            # min_Dprime = min_Dprime,
            # remove_correlates = remove_correlates,
            fillNA = fillNA,
            as_sparse = TRUE,
            nThread = nThread,
            conda_env = conda_env,
            download_method = download_method
        )
    } else if (endsWith(tolower(LD_reference), ".vcf") |
        endsWith(tolower(LD_reference), ".vcf.gz")) {
        #### Custom vcf ####
        LD_list <- custom_panel(
            LD_reference = LD_reference,
            LD_genome_build = LD_genome_build,
            dat = dat,
            locus_dir = locus_dir,
            force_new_LD = force_new_LD,
            # min_r2=min_r2,
            # min_Dprime=min_Dprime,
            # remove_correlates=remove_correlates,
            fillNA = fillNA, 
            LD_block_size = LD_block_size,
            remove_tmps = remove_tmps,
            nThread = nThread,
            conda_env = conda_env,
            verbose = verbose
        )
    } else {
        stop(
            "LD:: LD_reference input not recognized.",
            " Please supply: '1KGphase1', '1KGphase3',",
            " 'UKB', or the path to a .vcf[.gz] file."
        )
    }
    return(LD_list)
}
