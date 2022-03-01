download_UKB_LD <- function(LD.prefixes,
                            locus_dir,
                            alkes_url =
                                file.path(
                                    "https://data.broadinstitute.org",
                                    "alkesgroup/UKBB_LD"
                                ),
                            background = TRUE,
                            force_overwrite = FALSE,
                            download_method = "axel",
                            conda_env = "echoR",
                            nThread = parallel::detectCores() - 1) {
    for (f in LD.prefixes) {
        gz.url <- file.path(alkes_url, paste0(f, ".gz"))
        npz.url <- file.path(alkes_url, paste0(f, ".npz"))

        for (furl in c(gz.url, npz.url)) {
            out.file <- downloadR::downloader(
                input_url = furl,
                download_method = download_method,
                output_path = file.path(locus_dir, "LD"),
                background = background,
                conda_env = conda_env,
                nThread = nThread,
                force_overwrite = force_overwrite
            )
        }
    }
    return(gsub("*.npz$", "", out.file))
}
