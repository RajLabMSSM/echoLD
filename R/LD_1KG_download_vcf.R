#' Download VCF subset from 1000 Genomes
#'
#'
#' Query the 1000 Genomes Project for a subset of their individual-level VCF
#' files.
#' 
#' \code{
#' data("BST1")
#' vcf_subset.popDat <- LD_1KG_download_vcf(
#'     dat = BST1,
#'     LD_reference = "1KGphase1",
#'     locus_dir = file.path(tempdir(), locus_dir)
#' )
#' }
#' @family LD
#' @keywords internal
#'
#' @param query_by_regions You can make queries with \code{tabix}
#' in two different ways: 
#' \describe{
#' \item{\code{query_by_regions=F} \emph{(default)}}{
#' Return a vcf with all positions between the min/max in \code{dat}.
#' Takes up more storage but is MUCH faster}
#' \item{\code{query_by_regions=T}}{
#' Return a vcf with only the exact positions present in \code{dat}.
#'  Takes up less storage but is MUCH slower}
#' }
#' @inheritParams load_or_create  
LD_1KG_download_vcf <- function(dat,
                                LD_reference = "1KGphase1",
                                remote_LD = TRUE,
                                vcf_folder = NULL,
                                locus_dir,
                                locus = NULL,
                                whole_vcf = FALSE,
                                download_method = "axel",
                                force_new_vcf = FALSE,
                                query_by_regions = FALSE,
                                remove_tmps = TRUE,
                                nThread = 1,
                                conda_env = "echoR",
                                verbose = TRUE) {

    # Avoid confusing checks
    data <- NULL

    LD_reference <- tolower(LD_reference)[1]
    # throw error if anything but phase 1 or phase 3 are specified
    if (!LD_reference %in% c("1kgphase1", "1kgphase3")) {
        stop("LD_reference must be one of '1KGphase1' or '1KGphase3'.")
    }
    LD_reference <- tolower(LD_reference)[1]

    # Old FTP (deprecated?)
    ## http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/
    # New FTP
    ## ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/
    # Download portion of vcf from 1KG website
    # vcf_folder <- get_locus_vcf_folder(locus_dir=locus_dir)
    # Don't use the 'chr' prefix for 1KG queries:
    ## https://www.internationalgenome.org/faq/how-do-i-get-sub-section-vcf-file/
    dat$CHR <- gsub("chr", "", dat$CHR)
    chrom <- unique(dat$CHR)

    # PHASE 3 DATA
    if (LD_reference == "1kgphase3") {
        FTP <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20130502/"
        # FTP <- "/sc/arion/projects/ad-omics/data/references/1KGPp3v5/"'
        utils::data("popDat_1KGphase3")
        popDat <- popDat_1KGphase3
        messager("LD Reference Panel = 1KGphase3", v = verbose)
        if (remote_LD) { ## With internet
            messager("+ LD:: Querying 1KG remote server.", v = verbose)
            vcf_URL <- paste0(
                FTP, "/ALL.chr", chrom,
                ".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
            )
        } else { ## WithOUT internet
            # vcf_folder <-  "/sc/arion/projects/ad-omics/data/references/1KGPp3v5/"
            messager("+ LD:: Querying 1KG local vcf files.", v = verbose)
            vcf_URL <- paste(vcf_folder, "/ALL.chr", chrom,
                ".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz",
                sep = ""
            )
        }

        # PHASE 1 DATA
    } else if (LD_reference == "1kgphase1") {
        FTP <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/"
        utils::data("popDat_1KGphase1")
        popDat <- popDat_1KGphase1
        messager("LD Reference Panel = 1KGphase1", v = verbose)
        if (remote_LD) { ## With internet
            messager("+ LD:: Querying 1KG remote server.", v = verbose)
            vcf_URL <- paste(FTP, "/ALL.chr", chrom,
                ".phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz",
                sep = ""
            )
        } else { ## WithOUT internet
            messager("+ LD:: Querying 1KG local vcf files.", v = verbose)
            vcf_URL <- paste(vcf_folder, "/ALL.chr", chrom,
                ".phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz",
                sep = ""
            )
        }
    }
    phase <- gsub("1KG", "", LD_reference)
    # phase 1 has no header whereas phase 3 does
    if (LD_reference == "1kgphase1") {
        use_header <- FALSE
    }
    if (LD_reference == "1kgphase3") {
        use_header <- TRUE
    }
    # Download and subset vcf if the subset doesn't exist already
    vcf_subset <- query_vcf(
        dat = dat,
        vcf_URL = vcf_URL,
        locus_dir = locus_dir,
        LD_reference = LD_reference,
        whole_vcf = whole_vcf,
        force_new_vcf = force_new_vcf,
        download_method = download_method,
        query_by_regions = query_by_regions,
        nThread = nThread,
        conda_env = conda_env,
        verbose = verbose
    )
    #### Cleanup tbi ####
    if (remove_tmps) {
        vcf_cleaning()
        vcf_cleaning(locus_dir)
    }
    #### Return ####
    return(list(
        vcf_subset = vcf_subset,
        popDat = popDat
    ))
}
