UKB_find_ld_prefix <- function(chrom,
                               min_pos,
                               verbose = TRUE) {
    bp_starts <- seq(1, 252000001, by = 1000000)
    bp_ends <- bp_starts + 3000000
    i <- max(which(bp_starts <= min_pos))
    file.name <- paste0("chr", chrom, "_", bp_starts[i], "_", bp_ends[i])
    messager("+ UKB LD file name:", file.name, v = verbose)
    return(file.name)
}
