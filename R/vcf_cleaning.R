#' Remove old vcf files
#'
#' @keywords internal
vcf_cleaning <- function(root = ".",
                         LD_ref = "1KGphase3",
                         loci = NULL,
                         verbose = TRUE) {
    files <- list.files(root, paste0("*", LD_ref, ".vcf.gz|.vcf.gz.tbi", "*"),
        recursive = TRUE, full.names = TRUE
    )

    if (!is.null(loci)) {
        locus_names <- unique(basename(dirname(dirname(files))))
        select_loci <- dplyr::intersect(loci, locus_names)
        if (length(select_loci) > 0) {
            files <- files[locus_names %in% select_loci]
        }
    }
    if(length(files)>0){
        messager("Removing", length(files), "files.", v = verbose)
        out <- file.remove(files)   
    }
}
