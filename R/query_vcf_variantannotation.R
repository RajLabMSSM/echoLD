query_vcf_variantannotation <- function(vcf_url,
                                        dat) {
    # vcf_url <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521//ALL.chr18.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz"
    # dat <- echolocatoR::BST1
    # https://github.com/Bioconductor/VariantAnnotation/issues/29
    gr <- dt_to_granges(dat)

    #### Rsamtools ####
    # tab <- Rsamtools::scanTabix(file = vcf_url, gr)

    #### seqminer ####
    # tab <- seqminer::tabix.read(tabixFile = vcf_url, tabixRange = coord_range )

    #### VariantAnnotation::scanVcf ####
    vcf <- VariantAnnotation::VcfFile(
        file = vcf_url,
        index = paste0(vcf_url, ".tbi"),
        yieldSize = 5000
    )
    line <- VariantAnnotation::scanVcf(file = vcf)
    #### VariantAnnotation::readVcf ####
    vcf <- VariantAnnotation::VcfFile(
        file = vcf_url,
        index = paste0(vcf_url, ".tbi")
    )
    line2 <- VariantAnnotation::readVcf(
        file = vcf,
        genome = "hg19", param = gr
    )

    open(vcf)
    repeat {
        result <- VariantAnnotation::readVcf(vcf)
        if (length(result) == 0) {
              break
          }
        ## work on this chunk of the file
        message(nrow(result))
    }
    close(vcf)
    return(vcf)
}
