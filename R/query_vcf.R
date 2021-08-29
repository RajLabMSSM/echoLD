#' Query vcf file
#'
#' @family LD
#' @keywords internal
#' @examples
#' \dontrun{
#' data("locus_dir")
#' data("BST1")
#' # Custom
#' LD_reference <- "~/Desktop/results/Reference/custom_panel_chr4.vcf"
#' vcf_file <- index_vcf(vcf_file = LD_reference)
#' vcf_subset <- query_vcf(
#'     dat = BST1,
#'     locus_dir = locus_dir,
#'     vcf_URL = vcf_file,
#'     LD_reference = LD_reference,
#'     force_new_vcf = TRUE
#' )
#' }
query_vcf <- function(dat,
                      vcf_URL,
                      locus_dir,
                      LD_reference,
                      whole_vcf = FALSE,
                      force_new_vcf = FALSE,
                      remove_original_vcf = FALSE,
                      download_method = "wget",
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
            out.file <- downloader(
                input_url = vcf_URL,
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
                    vcf_URL,
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
                    vcf_URL,
                    coord_range,
                    ">",
                    gsub("\\./", "", vcf_subset)
                )
                messager(tabix_cmd)
                system(tabix_cmd)
            }
        }

        if (remove_original_vcf) {
            vcf_name <- paste0(basename(vcf_URL), ".tbi")
            out <- suppressWarnings(file.remove(vcf_name))
        }
    } else {
        messager("+ Identified existing VCF subset file. Importing...", vcf_subset, v = verbose)
    }
    return(vcf_subset)
}
