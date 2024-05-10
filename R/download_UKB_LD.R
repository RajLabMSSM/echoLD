#' Download UKB LD
#' 
#' Download UK Biobank Linkage Disequilibrium, 
#' pre-computed in 3Mb windows by the Alkes Price lab (Broad Institute).
#' 
#' @inheritParams get_LD
#' @inheritParams downloadR::aws
#' @inheritDotParams downloadR::aws
#' @keywords internal
#' @importFrom downloadR downloader
download_UKB_LD <- function(LD.prefixes,
                            locus_dir, 
                            bucket="s3://broad-alkesgroup-ukbb-ld/", 
                            background = TRUE,
                            force_overwrite = FALSE,
                            nThread = 1,
                            verbose = TRUE,
                            ...) { 
    for (f in LD.prefixes) {
        gz.url <- paste0("UKBB_LD/",f, ".gz")
        npz.url <- paste0("UKBB_LD/",f, ".npz")  
        for (furl in c(gz.url, npz.url)) {
            path <- file.path(locus_dir,"LD",furl)
            out.file <- downloadR::aws(
                input_url = furl,
                bucket = bucket,
                output_path = path,
                force_overwrite = force_overwrite,
                verbose = verbose,
                ...
            )
        }
    }
    return(gsub("*.npz$", "", out.file))
}
