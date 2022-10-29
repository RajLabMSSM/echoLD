#' Download UKB LD
#' 
#' Download UK Biobank Linkage Disequilibrium, 
#' pre-computed in 3Mb windows by the Alkes Price lab (Broad Institute).
#' 
#' @inheritParams get_LD
#' 
#' @keywords internal
#' @importFrom downloadR downloader
download_UKB_LD <- function(LD.prefixes,
                            locus_dir,
                            alkes_url =
                                paste(
                                    "https://data.broadinstitute.org",
                                    "alkesgroup/UKBB_LD",
                                    sep="/"
                                ),
                            background = TRUE,
                            force_overwrite = FALSE,
                            download_method = "axel",
                            conda_env = "echoR_mini",
                            nThread = 1,
                            verbose = TRUE) {
    for (f in LD.prefixes) {
        gz.url <- paste(alkes_url, paste0(f, ".gz"), sep="/")
        npz.url <- paste(alkes_url, paste0(f, ".npz"), sep="/")

        for (furl in c(gz.url, npz.url)) {
            out.file <- downloadR::downloader(
                input_url = furl,
                download_method = download_method,
                output_dir = file.path(locus_dir, "LD"),
                background = background,
                conda_env = conda_env,
                nThread = nThread,
                force_overwrite = force_overwrite,
                verbose = verbose
            )
        }
    }
    return(gsub("*.npz$", "", out.file))
}
