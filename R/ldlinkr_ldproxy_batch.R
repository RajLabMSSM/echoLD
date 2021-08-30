#' Extract LD proxies from 1KGphase3
#'
#' Wrapper for \code{LDlinkR::LDproxy_batch}.
#' Easy to use but doesn't scale up well to many SNPs (takes way too long).
#' 
#' \code{
#' data("merged_DT")
#' lead.snps <- setNames(subset(merged_DT, leadSNP)$Locus, 
#'                       subset(merged_DT, leadSNP)$SNP)
#' proxies <- ldlinkr_ldproxy_batch(snp = lead.snps)
#' }
#' 
#' @param min_corr Minimum correlation with \code{snp}.
#' @param save_dir Save folder.
#' @param verbose Print messages.
#' @inheritParams LDlinkR::LDproxy_batch
#' 
#' @family LD
#' @source
#' \href{https://www.rdocumentation.org/packages/LDlinkR/versions/1.0.2}{
#' website} 
#' @keywords internal
#' @importFrom LDlinkR LDproxy_batch
ldlinkr_ldproxy_batch <- function(snp,
                                  pop = "CEU",
                                  r2d = "r2",
                                  min_corr = FALSE,
                                  save_dir = NULL,
                                  verbose = TRUE) {
    messager("LD:LDlinkR:: Retrieving proxies of", length(snp), "SNPs",
        v = verbose
    )
    res <- LDlinkR::LDproxy_batch(
        snp = snp,
        pop = pop,
        r2d = r2d,
        append = TRUE,
        token = "df4298d58dc4"
    )
    messager("+ LD:LDlinkR::", length(unique(res$RS_Number)),
        "unique proxies returned.",
        v = verbose
    )
    if (min_corr != FALSE) {
        res <- subset(res, eval(parse(text = toupper(r2d))) >= min_corr)
        messager("+ LD:LDlinkR::", length(unique(res$RS_Number)),
            "remaining at", r2d, " >=", min_corr,
            v = verbose
        )
    }
    proxy_files <- "combined_query_snp_list.txt" # Automatically named
    if (!is.null(save_dir)) {
        # LDproxy_batch() saves all results  as individual 
        #.txt files in the cwd by default.
        ## It's pretty dumb that they don't let you control if 
        #and where these are saved,
        ## so we have to do this manually afterwards.
        # local_dir <- "~/Desktop"
        # proxy_files <- list.files(path= "./",
        #                           pattern = "^rs.*\\.txt$", full.names = T)
        new_path <- file.path(save_dir, basename(proxy_files))
        out <- file.rename(proxy_files, new_path)
        return(new_path)
    } else {
        return(proxy_files)
    }
}
