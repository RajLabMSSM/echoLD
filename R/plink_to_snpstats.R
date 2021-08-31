plink_to_snpstats <- function(vcf_subset,
                              LD_reference,
                              superpopulation,
                              select_snps,
                              locus_dir,
                              nThread = 1,
                              verbose = TRUE) {
    vcf.gz.path <- filter_vcf_cli(
        vcf_subset = vcf_subset,
        LD_reference = LD_reference,
        superpopulation = superpopulation,
        remove_tmp = TRUE,
        verbose = verbose
    )
    bed_bim_fam <- vcf_to_bed_cli(
        vcf.gz.subset = vcf.gz.path,
        locus_dir = locus_dir,
        verbose = verbose
    )
    # dir.create(LD_folder, showWarnings = FALSE, recursive = TRUE)
    # select_snps= arg needed bc otherwise read.plink() sometimes complains of
    ## duplicate RSID rownames. Also need to check whether these
    # SNPs exist in the plink files.
    ## (snpStats doesn't have very good error handling for these cases).
    select_snps <- snpstats_ensure_nonduplicates(
        select_snps = select_snps,
        bim_path = bed_bim_fam$bim,
        nThread = nThread,
        verbose = verbose
    )
    # Only need to give bed path (infers bin/fam paths)
    ss <- snpStats::read.plink(
        bed = bed_bim_fam$bed,
        select.snps = select_snps
    )
    return(ss)
}
