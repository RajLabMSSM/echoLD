determine_chrom_type_vcf <- function(vcf_file,
                                     conda_env = "echoR",
                                     verbose = T) {
    vcf <- gaston::read.vcf(vcf_file, max.snps = 1, convert.chr = FALSE)
    has_chr <- grepl("chr", vcf@snps$chr[1])
    # bcftools <-echoconda::find_package(package = "bcftools",
    #                                conda_env = conda_env,
    #                                verbose = verbose)
    # # bcf_cmd <- paste("bcftools view -f '%CHROM' -H",vcf_file,"|head -1")
    # header <- data.table::fread(cmd=bcf_cmd)
    return(has_chr)
}
