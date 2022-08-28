#' Download LD matrices from UK Biobank
#'
#' Download pre-computed LD matrices from
#' \href{https://www.ukbiobank.ac.uk}{UK Biobank} in 3Mb windows,
#' then subset to the region that overlaps with \code{query_dat}.\cr\cr
#' LD was derived from a  British, European-decent subpopulation
#' in the UK Biobank. LD was pre-computed and stored by the Alkes Price lab.
#' All data is aligned to the hg19 reference genome.
#' For further details, see the 
#' \href{http://dx.doi.org/10.1038/s41588-020-00735-5}{PolyFun publication}.
#'
#' @param download_method If "python" will import compressed numpy array
#' directly into R using \pkg{reticulate}. Otherwise, will be passed to
#' \link[downloadR]{downloader} to download the full 3Mb-window LD matrix first.
#' @param local_storage Path to folder with previously download LD npz files.
#' @inheritParams get_LD 
#'
#' @family LD
#' @keywords internal
#' @importFrom data.table fread data.table
#' @importFrom reticulate source_python
#' @importFrom downloadR downloader
#' @importFrom echotabix liftover
#' @source
#' \code{
#' query_dat <- echodata::BST1[seq(1, 50), ]
#' locus_dir <- file.path(tempdir(), echodata::locus_dir)
#' LD_list <- echoLD:::get_LD_UKB(
#'     query_dat = query_dat,
#'     locus_dir = locus_dir)
#' }
get_LD_UKB <- function(query_dat,
                       query_genome = "hg19",
                       locus_dir,
                       chrom = NULL,
                       min_pos = NULL,
                       force_new_LD = FALSE,
                       local_storage = NULL,
                       download_full_ld = FALSE,
                       download_method = "axel",
                       fillNA = 0,
                       nThread = 1,
                       return_matrix = TRUE,
                       as_sparse = TRUE,
                       conda_env = "echoR_mini",
                       remove_tmps = TRUE,
                       verbose = TRUE) {
    
    # echoverseTemplate:::source_all();
    # echoverseTemplate:::args2vars(get_LD_UKB)
    load_ld <- NULL

    messager("Using UK Biobank LD reference panel.", v = verbose)
    #### Liftover ####
    query_dat <- echotabix::liftover(dat = query_dat, 
                                     query_genome = query_genome, 
                                     target_genome = "hg19",
                                     verbose = verbose)
    #### Prepare query ####  
    chrom <- unique(query_dat$CHR)
    min_pos <- min(query_dat$POS)
    LD.prefixes <- UKB_find_ld_prefix(
        chrom = chrom,
        min_pos = min_pos
    ) 
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
    #### Check if empty ####
    if(file.exists(RDS_path) && 
       file.info(RDS_path)$size<100) {
        messager("Removing empty UKB_LD.RDS file.",v=verbose)
        file.remove(RDS_path)
    }
    method_opts <- eval(formals(downloadR::downloader)$download_method)
    #### Check if already exists ####
    if (file.exists(RDS_path) & isFALSE(force_new_LD)) {
        messager("Pre-existing UKB_LD.RDS file detected. Importing",
            RDS_path,
            v = verbose
        )
        ld_R <- readRDS(RDS_path)
    } else {
        if (download_method != "python") {
            if (download_full_ld |
                force_new_LD |
                download_method %in% method_opts) {
                messager(
                    "Downloading full .gz/.npz UKB files",
                    "and saving to disk."
                )
                URL <- download_UKB_LD(
                    LD.prefixes = LD.prefixes,
                    locus_dir = locus_dir,
                    background = FALSE,
                    force_overwrite = force_new_LD,
                    conda_env = conda_env,
                    download_method = download_method,
                    nThread = nThread
                )
            } else {
                #### Check for existing gz/npz files ####
                if (!is.null(local_storage)) {
                    gz_file <- file.path(local_storage,
                                         paste0(LD.prefixes,".gz"))
                    npz_file <- file.path(local_storage,
                                          paste0(LD.prefixes,".npz"))
                    if (file.exists(gz_file) &&
                        file.exists(npz_file)) {
                        messager("Pre-existing UKB LD",
                            "gz/npz files detected. Importing...",
                            v = verbose
                        )
                        URL <- local_storage
                    }
                } else {
                    URL <- paste(URL, LD.prefixes, sep="/")
                    messager("Importing UKB LD file",
                        "directly to R from:",
                        v = verbose
                    )
                }
            }
        } else {
            URL <- paste(URL, LD.prefixes, sep="/")
            messager("Importing UKB LD file directly to R from:",v = verbose)
        } 
        #### Import LD via python function #### 
        reticulate::source_python(
            system.file("tools", "load_ld.py",package = "echoLD"
        ))
        messager("load_ld() python function input:",URL,v = verbose)
        messager("Reading LD matrix into memory.",
                 "This could take some time...",v = verbose)
        server <- FALSE
        ld.out <- tryFunc(input = URL, load_ld, server)
        #### LD matrix: as matrix ####
        ld_R <- ld.out[[1]]
        messager("+ Full UKB LD matrix:",
            paste(formatC(dim(ld_R),big.mark = ","), collapse = " x "),
            v = verbose
        )
        #### SNP info: as data.table ####
        ld_snps <- data.table::data.table(ld.out[[2]])
        messager("+ Full UKB LD SNP data.table:",
            paste(formatC(dim(ld_snps),big.mark = ","), collapse = " x "),
            v = verbose
        )
        #### Remove ld.out ####
        remove(ld.out)
        #### Add row/col names to LD matrix ####
        if (is.null(row.names(ld_R))) row.names(ld_R) <- ld_snps$rsid
        if (is.null(colnames(ld_R))) colnames(ld_R) <- ld_snps$rsid
        #### As a last resort download UKB MAF ####
        if (!"MAF" %in% colnames(query_dat)) { 
           query_dat<- get_UKB_MAF(
               query_dat = query_dat,  
                nThread = nThread,
                download_method = download_method,
                conda_env = conda_env,
                verbose = verbose
            )
        }
        #### Save ####
        LD_list <- save_LD_matrix(
            LD_matrix = ld_R,
            dat = query_dat,
            locus_dir = locus_dir,
            LD_reference = "UKB",
            as_sparse = as_sparse,
            verbose = verbose
        )
        #### Remove temp files ####
        if (isTRUE(remove_tmps)) { 
            clean_UKB_tmps(URL=URL,
                           verbose=verbose)
        }
    }
    #### Return ####
    if (return_matrix) {
        return(LD_list)
    } else {
        return(RDS_path)
    }
}
