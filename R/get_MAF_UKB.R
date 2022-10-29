#' Get MAF from UK Biobank.
#'
#' If \strong{MAF} column is missing,
#' download MAF from UK Biobank and use that instead.
#'
#' @param query_dat SNP-level data.
#' @param output_dir Path to store UKB_MAF file in.
#' @param force_new_maf Download UKB_MAF file again.
#' @param verbose Print messages.
#' @inheritParams downloadR::downloader
#'
#' @family standardizing functions 
#' @source \href{http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=22801}{UKB}
#' @export
#' @importFrom data.table fread merge.data.table data.table
#' @importFrom dplyr group_by slice rename
#' @importFrom tools R_user_dir
#' @importFrom downloadR downloader
#' 
#' @examples
#' query_dat<- echodata::BST1
#' query_dat$MAF <- NULL
#' dat2 <- echoLD::get_MAF_UKB(query_dat = query_dat)
get_MAF_UKB <- function(query_dat,
                        output_dir = tools::R_user_dir(package = "echoLD",
                                                       which = "cache"),
                        force_new_maf = FALSE,
                        download_method = "axel",
                        nThread = 1,
                        verbose = TRUE,
                        conda_env = "echoR_mini") {
    # Avoid confusing checks
    POS <- MAF <- SNP <- NULL;

    messager("UKB MAF:: Extracting MAF from UKB reference.", v = verbose)
    chrom <- unique(query_dat$CHR)
    input_url <- paste0(
        file.path(
            "biobank.ctsu.ox.ac.uk",
            "showcase/showcase/auxdata/ukb_mfi_chr"
        ),
        chrom, "_v3.txt"
    )
    out_file <- file.path(output_dir, basename(input_url))
    if (file.exists(out_file)) {
        if (file.size(out_file) == 0) {
            messager("+ UKB MAF:: Removing empty UKB MAF ref file.",v=verbose)
            file.remove(out_file)
        }
    }
    if (file.exists(out_file) & (!force_new_maf)) {
        messager("+ UKB MAF:: Importing pre-existing file", v = verbose)
    } else {
        out_file <- downloadR::downloader(
            input_url = input_url,
            output_dir = output_dir,
            background = FALSE,
            force_overwrite = force_new_maf,
            download_method = download_method,
            nThread = nThread,
            conda_env = conda_env
        )
    }
    maf <- data.table::fread(out_file,
        nThread = nThread,
        select = c(3, 6),
        col.names = c("POS", "MAF")
    )
    maf <- subset(maf, POS %in% query_dat$POS)
    if ("MAF" %in% colnames(query_dat)) {
        messager(" UKB MAF:: Existing 'MAF' col detected.",
            "Naming UKB MAF col 'MAF_UKB'",
            v = verbose
        )
        maf <- dplyr::rename(maf, MAF_UKB = MAF)
    }
    merged_dat <- data.table::merge.data.table(query_dat, maf,
        by = "POS"
    ) |>
        # Make sure each SNP just appears once
        dplyr::group_by(SNP) |>
        dplyr::slice(1) |>
        data.table::data.table()
    return(merged_dat)
}
