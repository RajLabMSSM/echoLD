#' Download LD matrices from UK Biobank
#'
#' Download pre-computed LD matrices from UK Biobank in 3Mb windows,
#' then subset to the region that overlaps with \code{dat}.
#'
#' @family LD
#' @keywords internal
#' @importFrom data.table fread data.table
#' @importFrom  reticulate source_python
LD_ukbiobank <- function(dat = NULL,
                         locus_dir,
                         sumstats_path = NULL,
                         chrom = NULL,
                         min_pos = NULL,
                         force_new_LD = FALSE,
                         chimera = FALSE,
                         server = TRUE,
                         download_full_ld = FALSE,
                         download_method = "direct",
                         fillNA = 0,
                         nThread = 1,
                         return_matrix = FALSE,
                         as_sparse = TRUE,
                         conda_env = "echoR",
                         remove_tmps = TRUE,
                         verbose = TRUE) {
    messager("LD:: Using UK Biobank LD reference panel.", v = verbose)
    #### Prepare finemap_dat ####
    if (!is.null(dat)) {
        finemap_dat <- dat
    } else if (!is.null(sumstats_path)) {
        messager("+ Assigning chrom and min_pos based on summary stats file",
            v = verbose
        )
        # sumstats_path="./example_data/BST1_Nalls23andMe_2019_subset.txt"
        finemap_dat <- data.table::fread(
            input = sumstats_path,
            nThread = nThread
        )
    }
    chrom <- unique(finemap_dat$CHR)
    min_pos <- min(finemap_dat$POS)
    LD.prefixes <- UKB_find_ld_prefix(
        chrom = chrom,
        min_pos = min_pos
    )
    chimera.path <- "/sc/orga/projects/pd-omics/tools/polyfun/UKBB_LD"
    alkes_url <- "https://data.broadinstitute.org/alkesgroup/UKBB_LD"
    URL <- alkes_url

    #### Create LD locus dir ####
    LD_dir <- file.path(locus_dir, "LD")
    dir.create(LD_dir, showWarnings = FALSE, recursive = TRUE)
    locus <- basename(locus_dir)
    # RDS_path <- file.path(LD_dir, paste0(locus,".UKB_LD.RDS"))
    RDS_path <- get_rds_path(
        locus_dir = locus_dir,
        LD_reference = "UKB"
    )

    if (file.exists(RDS_path) & force_new_LD == F) {
        messager("+ LD:: Pre-existing UKB_LD.RDS file detected. Importing",
            RDS_path,
            v = verbose
        )
        LD_matrix <- readRDS(RDS_path)
    } else {
        if (download_method != "direct") {
            if (download_full_ld |
                force_new_LD |
                download_method %in% c("wget", "axel")) {
                messager(
                    "+ LD:: Downloading full .gz/.npz UKB files",
                    "and saving to disk."
                )
                URL <- download_UKB_LD(
                    LD.prefixes = LD.prefixes,
                    locus_dir = locus_dir,
                    background = FALSE,
                    force_overwrite = force_new_LD,
                    download_method = download_method
                )
                server <- FALSE
            } else {
                if (chimera) {
                    if (file.exists(file.path(
                        chimera.path,
                        paste0(LD.prefixes, ".gz")
                    )) &
                        file.exists(file.path(
                            chimera.path,
                            paste0(LD.prefixes, ".npz")
                        ))) {
                        messager("+ LD:: Pre-existing UKB LD",
                            "gz/npz files detected. Importing...",
                            v = verbose
                        )
                        URL <- chimera.path
                    }
                } else {
                    URL <- file.path(URL, LD.prefixes)
                    messager("+ LD:: Importing UKB LD file",
                        "directly to R from:",
                        v = verbose
                    )
                }
            }
        } else {
            URL <- file.path(URL, LD.prefixes)
            messager("+ LD:: Importing UKB LD file directly to R from:",
                v = verbose
            )
        }

        #### Import LD via python function ####
        # echoconda::activate_env(conda_env = conda_env,
        #                    verbose = verbose)
        reticulate::source_python(system.file("tools", "load_ld.py",
            package = "echolocatoR"
        ))
        messager("+ LD:: load_ld() python function input:",
            URL,
            v = verbose
        )
        messager("+ LD:: Reading LD matrix into memory.",
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
        if (!"MAF" %in% colnames(dat)) {
            output_path <- file.path(
                dirname(dirname(dirname(locus_dir))),
                "Reference/UKB_MAF"
            )
            dat <- get_UKB_MAF(
                dat = dat,
                output_path = output_path,
                force_new_maf = FALSE,
                nThread = nThread,
                download_method = "axel",
                verbose = verbose
            )
        }
        # Save LD matrix as RDS
        RDS_path <- save_LD_matrix(
            LD_matrix = ld_R,
            dat = dat,
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
            DT = dat,
            LD = ld_R,
            RDS_path = RDS_path
        ))
    } else {
        return(RDS_path)
    }
}
