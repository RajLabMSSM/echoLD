get_1KG_url <- function(LD_reference,
                        chrom,
                        local_storage = NULL,
                        verbose = TRUE) {
    # Old FTP (deprecated?)
    ## http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/
    # New FTP
    ## ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/
    # Download portion of vcf from 1KG website
    # local_storage <- get_locus_vcf_folder(locus_dir=locus_dir)
    # Don't use the 'chr' prefix for 1KG queries:
    ## https://www.internationalgenome.org/faq/how-do-i-get-sub-section-vcf-file/

    LD_reference <- tolower(LD_reference[1])
    #### PHASE 3 DATA ####
    if (LD_reference == "1kgphase3") {
        FTP <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20130502/"
        messager("LD Reference Panel = 1KGphase3", v = verbose)
        if (is.null(local_storage)) { ## With internet
            messager("Querying 1KG remote server.", v = verbose)
            vcf_url <- paste0(
                FTP, "/ALL.chr", chrom,
                ".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
            )
        } else { ## WithOUT internet
            messager("Querying 1KG local vcf files.", v = verbose)
            vcf_url <- paste(local_storage, "/ALL.chr", chrom,
                ".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz",
                sep = ""
            )
        }
        #### PHASE 1 DATA ####
    } else if (LD_reference == "1kgphase1") {
        FTP <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/"
        messager("LD Reference Panel = 1KGphase1", v = verbose)
        if (is.null(local_storage)) { ## With internet
            messager("Querying 1KG remote server.", v = verbose)
            vcf_url <- paste(FTP, "/ALL.chr", chrom,
                ".phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz",
                sep = ""
            )
        } else { ## WithOUT internet
            messager("Querying 1KG local vcf files.", v = verbose)
            vcf_url <- paste(local_storage, "/ALL.chr", chrom,
                ".phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz",
                sep = ""
            )
        }
    }
    return(vcf_url)
}
