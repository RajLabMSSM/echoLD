#' Calculate LD (D')
#'
#' This approach computes an LD matrix of D' (instead of r or r2) from a vcf.
#' See \code{run_plink_LD} for a faster
#' (but less flexible) alternative to computing LD.
#'
#' @family LD
#' @keywords internal
#' @importFrom data.table fread
#' @importFrom stats complete.cases
dprime_table <- function(SNP_list,
                         LD_folder,
                         conda_env = "echoR") {
    plink <- plink_file(conda_env = conda_env)
    messager("+ Creating DPrime table")
    system(paste(
        plink, "--bfile", file.path(LD_folder, "plink"),
        "--ld-snps", paste(SNP_list, collapse = " "),
        "--r dprime-signed",
        "--ld-window 10000000", # max out window size
        "--ld-window-kb 10000000",
        "--out", file.path(LD_folder, "plink")
    ))
    #--ld-window-r2 0

    # # Awk method: theoretically faster?
    # if(min_Dprime==F){Dprime = -1}else{Dprime=min_Dprime}
    # if(min_r2==F){r = -1}else{r = round(sqrt(min_r2),2) }
    # columns <- data.table::fread(file.path(LD_folder, "plink.ld"), nrows = 0) %>% colnames()
    # col_dict <- setNames(1:length(columns), columns)
    # awk_cmd <- paste("awk -F \"\t\" 'NR==1{print $0}{ if(($",col_dict["DP"]," >= ",Dprime,")",
    #                  " && ($",col_dict["R"]," >= ",r,")) { print } }' ",file.path(LD_folder, "plink.ld"),
    #                  " > ",file.path(LD_folder, "plink.ld_filtered.txt"),  sep="")
    # system(awk_cmd)
    plink.ld <- data.table::fread(file.path(LD_folder, "plink.ld"),
        select = c("SNP_A", "SNP_B", "DP", "R"),
    )
    plink.ld <- plink.ld[stats::complete.cases(plink.ld)]
    return(plink.ld)
}
