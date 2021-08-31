#' Get MAF from UK Biobank.
#'
#' If \strong{MAF} column is missing,
#' download MAF from UK Biobank and use that instead.
#'
#' @param dat SNP-level data.
#' @param output_path Path to store UKB_MAF file in.
#' @param force_new_maf Download UKB_MAF file again.
#' @param verbose Print messages.
#' @inheritParams downloadR::downloader
#'
#' @family standardizing functions
#' @examples
#' data("BST1")
#' dat <- data.frame(BST1)[, colnames(BST1) != "MAF"]
#' BST1 <- get_UKB_MAF(dat = dat)
#' @source \href{http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=22801}{UKB}
#' @export
#' @importFrom data.table fread merge.data.table data.table
#' @importFrom dplyr %>% group_by slice rename
get_UKB_MAF <- function(dat,
                        output_path = file.path(
                            tempdir(),
                            "Data/Reference/UKB_MAF"
                        ),
                        force_new_maf = FALSE,
                        download_method = "axel",
                        nThread = 1,
                        verbose = TRUE,
                        conda_env = "echoR") {
    # Avoid confusing checks
    POS <- MAF <- SNP <- NULL

    messager("UKB MAF:: Extracting MAF from UKB reference.", v = verbose)
    chrom <- unique(dat$CHR)
    input_url <- paste0(
        file.path(
            "biobank.ctsu.ox.ac.uk",
            "showcase/showcase/auxdata/ukb_mfi_chr"
        ),
        chrom, "_v3.txt"
    )
    out_file <- file.path(output_path, basename(input_url))
    if (file.exists(out_file)) {
        if (file.size(out_file) == 0) {
            messager("+ UKB MAF:: Removing empty UKB MAF ref file.")
            file.remove(out_file)
        }
    }
    if (file.exists(out_file) & (!force_new_maf)) {
        messager("+ UKB MAF:: Importing pre-existing file", v = verbose)
    } else {
        out_file <- downloadR::downloader(
            input_url = input_url,
            output_path = output_path,
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
    maf <- subset(maf, POS %in% dat$POS)
    if ("MAF" %in% colnames(dat)) {
        messager(" UKB MAF:: Existing 'MAF' col detected.",
            "Naming UKB MAF col 'MAF_UKB'",
            v = verbose
        )
        maf <- dplyr::rename(maf, MAF_UKB = MAF)
    }
    merged_dat <- data.table::merge.data.table(dat, maf,
        by = "POS"
    ) %>%
        # Make sure each SNP just appears once
        dplyr::group_by(SNP) %>%
        dplyr::slice(1) %>%
        data.table::data.table()
    return(merged_dat)
}
