remove_empty_vcf <- function(f,
                             verbose = TRUE) {
    if (file.exists(f)) {
        if (file.size(f) < 100) { # Less than 100 bytes
            messager("+ LD:: Removing empty VCF file and its index", v = verbose)
            file.remove(paste0(f, "*")) # Remove both
        }
    }
}
