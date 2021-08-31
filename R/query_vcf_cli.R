#' Query VCF file: CLI
#'
#' Query a (remote) VCF file using the Command Line Interface (CLI)
#' @family LD
#' @keywords internal
#' @importFrom echoconda find_package
#' @importFrom downloadR downloader
#' @importFrom data.table fwrite
query_vcf_cli <- function(dat,
                          vcf_url,
                          locus_dir,
                          LD_reference,
                          whole_vcf = FALSE,
                          force_new_vcf = FALSE,
                          remove_original_vcf = FALSE,
                          download_method = "download.file",
                          query_by_regions = FALSE,
                          nThread = 1,
                          conda_env = "echoR",
                          verbose = TRUE) {
    # vcf_subset <- "/pd-omics/brian/Fine_Mapping/Data/GWAS/Nalls23andMe_2019/BRIP1/LD/BRIP1.1KGphase3.vcf.gz"
    vcf_subset <- construct_subset_vcf_name(
        dat = dat,
        locus_dir = locus_dir,
        LD_reference = LD_reference,
        whole_vcf = whole_vcf
    )
    # CHECK FOR EMPTY VCF FILES!
    ## These can be created if you stop the query early, or if the url fails.
    if (file.exists(vcf_subset)) {
        if (file.size(vcf_subset) < 100) { # Less than 100 bytes
            messager("+ LD:: Removing empty vcf file and its index", v = verbose)
            file.remove(paste0(vcf_subset, "*")) # Remove both
        }
    }
    tabix <- echoconda::find_package(
        package = "tabix",
        conda_env = conda_env,
        verbose = verbose
    )
    if ((!file.exists(vcf_subset)) | force_new_vcf) {
        messager("LD:: Querying VCF subset", v = verbose)
        if (whole_vcf) {
            region <- ""
            locus <- ""
            out.file <- downloadR::downloader(
                input_url = vcf_url,
                output_path = dirname(vcf_subset),
                download_method = download_method,
                nThread = nThread,
                conda_env = conda_env
            )
        } else {
            # Download tabix subset
            if (query_by_regions) {
                ### Using region file (-R flag)
                regions.bed <- file.path(locus_dir, "LD", "regions.tsv")
                data.table::fwrite(list(paste0(dat$CHR), sort(dat$POS)),
                    file = regions.bed, sep = "\t"
                )
                regions <- paste("-R", regions.bed)
                tabix_cmd <- paste(
                    tabix,
                    "-fh",
                    "-p vcf",
                    vcf_url,
                    gsub("\\./", "", regions),
                    ">",
                    gsub("\\./", "", vcf_subset)
                )
                messager(tabix_cmd)
                system(tabix_cmd)
            } else {
                ### Using coordinates range (MUCH faster!)
                coord_range <- paste0(
                    unique(dat$CHR)[1], ":",
                    min(dat$POS), "-", max(dat$POS)
                )
                tabix_cmd <- paste(
                    tabix,
                    "-fh",
                    "-p vcf",
                    vcf_url,
                    coord_range,
                    ">",
                    gsub("\\./", "", vcf_subset)
                )
                messager(tabix_cmd)
                system(tabix_cmd)
            }
        }

        if (remove_original_vcf) {
            vcf_name <- paste0(basename(vcf_url), ".tbi")
            out <- suppressWarnings(file.remove(vcf_name))
        }
    } else {
        messager("+ Identified existing VCF subset file. Importing...", vcf_subset, v = verbose)
    }
    return(vcf_subset)
}
