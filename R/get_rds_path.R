get_rds_path <- function(locus_dir,
                         LD_reference) {
    RDS_path <- file.path(
        locus_dir, "LD",
        paste0(
            basename(locus_dir), ".",
            basename(LD_reference), "_LD.RDS"
        )
    )
    return(RDS_path)
}
