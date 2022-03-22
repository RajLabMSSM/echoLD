#' Download LD matrices from UK Biobank
#'
#' Download pre-computed LD matrices from
#' \href{https://www.ukbiobank.ac.uk}{UK Biobank} in 3Mb windows,
#' then subset to the region that overlaps with \code{query_dat}.
#'
#' LD was derived from a  British, European-decent subpopulation
#' in the UK Biobank. LD was pre-computed and stored by the Alkes Price lab
#' (see \href{https://www.biorxiv.org/content/10.1101/807792v3}{here}).
#'
#' @param download_method If "python" will import compressed numpy array
#' directly into R using \pkg{reticulate}. Otherwise, will be passed to
#' \link[downloadR]{downloader} to download the full 3Mb-window LD matrix first.
#' @param local_storage Path to folder with previously download LD npz files.
#' @inheritParams load_or_create 
#'
#' @family LD
#' @keywords internal
#' @importFrom data.table fread data.table
#' @importFrom  reticulate source_python
LD_ukbiobank <- function(query_dat = NULL,
                         locus_dir,
                         sumstats_path = NULL,
                         chrom = NULL,
                         min_pos = NULL,
                         force_new_LD = FALSE,
                         local_storage = NULL,
                         download_full_ld = FALSE,
                         download_method = "python",
                         fillNA = 0,
                         nThread = 1,
                         return_matrix = FALSE,
                         as_sparse = TRUE,
                         conda_env = "echoR",
                         remove_tmps = TRUE,
                         verbose = TRUE) {
    # Avoid confusing checks
    load_ld <- NULL

    messager("echoLD:: Using UK Biobank LD reference panel.", v = verbose)
    #### Preparequery_dat####
    if (!is.null(query_dat)) {
       query_dat<- query_dat
    } else if (!is.null(sumstats_path)) {
        messager("+ Assigning chrom and min_pos based on summary stats file",
            v = verbose
        )
        # sumstats_path="./example_data/BST1_Nalls23andMe_2019_subset.txt"
       query_dat<- data.table::fread(
            input = sumstats_path,
            nThread = nThread
        )
    }
    chrom <- unique(query_dat$CHR)
    min_pos <- min(query_dat$POS)
    LD.prefixes <- UKB_find_ld_prefix(
        chrom = chrom,
        min_pos = min_pos
    )
    # chimera.path <- "/sc/orga/projects/pd-omics/tools/polyfun/UKBB_LD"
    alkes_url <- "https://data.broadinstitute.org/alkesgroup/UKBB_LD"
    URL <- alkes_url

    #### Create LD locus dir ####
    LD_dir <- file.path(locus_dir, "LD")
    dir.create(LD_dir, showWarnings = FALSE, recursive = TRUE) 
    # RDS_path <- file.path(LD_dir, paste0(locus,".UKB_LD.RDS"))
    RDS_path <- get_rds_path(
        locus_dir = locus_dir,
        LD_reference = "UKB"
    )

    if (file.exists(RDS_path) & force_new_LD == FALSE) {
        messager("+ echoLD:: Pre-existing UKB_LD.RDS file detected. Importing",
            RDS_path,
            v = verbose
        )
        ld_R <- readRDS(RDS_path)
    } else {
        if (download_method != "python") {
            if (download_full_ld |
                force_new_LD |
                download_method %in% c("wget", "axel")) {
                messager(
                    "+ echoLD:: Downloading full .gz/.npz UKB files",
                    "and saving to disk."
                )
                URL <- download_UKB_LD(
                    LD.prefixes = LD.prefixes,
                    locus_dir = locus_dir,
                    background = FALSE,
                    force_overwrite = force_new_LD,
                    conda_env = conda_env,
                    download_method = download_method
                )
            } else {
                if (!is.null(local_storage)) {
                    if (file.exists(file.path(
                        local_storage,
                        paste0(LD.prefixes, ".gz")
                    )) &
                        file.exists(file.path(
                            local_storage,
                            paste0(LD.prefixes, ".npz")
                        ))) {
                        messager("+ echoLD:: Pre-existing UKB LD",
                            "gz/npz files detected. Importing...",
                            v = verbose
                        )
                        URL <- local_storage
                    }
                } else {
                    URL <- file.path(URL, LD.prefixes)
                    messager("+ echoLD:: Importing UKB LD file",
                        "directly to R from:",
                        v = verbose
                    )
                }
            }
        } else {
            URL <- file.path(URL, LD.prefixes)
            messager("+ echoLD:: Importing UKB LD file directly to R from:",
                v = verbose
            )
        }

        #### Import LD via python function ####
        # echoconda::activate_env(conda_env = conda_env,
        #                    verbose = verbose)
        reticulate::source_python(system.file("tools", "load_ld.py",
            package = "echodata"
        ))
        messager("+ echoLD:: load_ld() python function input:",
            URL,
            v = verbose
        )
        messager("+ echoLD:: Reading LD matrix into memory.",
            "This could take some time...",
            v = verbose
        )
        server <- FALSE
        ld.out <- tryFunc(input = URL, load_ld, server)
        # LD matrix
        ld_R <- ld.out[[1]]
        messager("+ Full UKB LD matrix:",
            paste(dim(ld_R), collapse = " x "),
            v = verbose
        )
        ld_snps <- data.table::data.table(ld.out[[2]])
        messager("+ Full UKB LD SNP data.table:",
            paste(dim(ld_snps), collapse = " x "),
            v = verbose
        )
        if (is.null(row.names(ld_R))) row.names(ld_R) <- ld_snps$rsid
        if (is.null(colnames(ld_R))) colnames(ld_R) <- ld_snps$rsid

        # As a last resort download UKB MAF
        if (!"MAF" %in% colnames(query_dat)) {
            output_path <- file.path(
                dirname(dirname(dirname(locus_dir))),
                "Reference/UKB_MAF"
            )
           query_dat<- get_UKB_MAF(
               query_dat = query_dat,
                output_path = output_path,
                force_new_maf = FALSE,
                nThread = nThread,
                download_method = "axel",
                verbose = verbose
            )
        }
        #### Convert to sparse ####
        if(as_sparse){
            ld_R <- to_sparse(X = ld_R,
                              verbose = verbose)
        }
        RDS_path <- save_LD_matrix(
            LD_matrix = ld_R,
            dat = query_dat,
            locus_dir = locus_dir,
            LD_reference = "UKB",
            as_sparse = as_sparse,
            verbose = verbose
        )
        if (remove_tmps) {
            messager("+ Removing .gz/.npz files.")
            if (file.exists(paste0(URL, ".gz"))) {
                file.remove(paste0(URL, ".gz"))
            }
            if (file.exists(paste0(URL, ".npz"))) {
                file.remove(paste0(URL, ".npz"))
            }
        }
    }
    if (return_matrix) {
        return(list(
            query_dat = query_dat,
            LD = ld_R,
            RDS_path = RDS_path
        ))
    } else {
        return(RDS_path)
    }
}
