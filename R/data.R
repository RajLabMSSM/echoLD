#' Population metadata: 1KGphase1
#'
#' Individual-level metadata for 1000 Genomes Project (Phase 1).
#'
#' @family LD
#' @source
#' \code{
#' popDat_URL <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/phase1_integrated_calls.20101123.ALL.panel"
#' popDat_1KGphase1 <- data.table::fread(text = trimws(gsub(",\t", ",", readLines(popDat_URL))), sep = "\t", fill = T, stringsAsFactors = F, col.names = c("sample", "population", "superpop", "sex"), nThread = 4)
#' usethis::use_data(popDat_1KGphase1, overwrite  =  TRUE)
#' }
#' @format data.table
#' @usage data("popDat_1KGphase1")
"popDat_1KGphase1"


#' Population metadata: 1KGphase3
#'
#' Individual-level metadata for 1000 Genomes Project (Phase 3).
#'
#' @family LD
#' @source
#' \code{
#' popDat_URL <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel"
#' popDat_1KGphase3 <- data.table::fread(text = trimws(gsub(",\t", ",", readLines(popDat_URL))), sep = "\t", fill = T, stringsAsFactors = F, col.names = c("sample", "population", "superpop", "sex"), nThread = 4)
#' usethis::use_data(popDat_1KGphase3, overwrite  =  TRUE)
#' }
#' @format data.table
#' @usage data("popDat_1KGphase3")
"popDat_1KGphase3"
