% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{popDat_1KGphase3}
\alias{popDat_1KGphase3}
\title{Population metadata: 1KGphase3}
\format{
data.table
}
\source{
\code{
popDat_URL <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel"
popDat_1KGphase3 <- data.table::fread(text = trimws(gsub(",\t", ",", readLines(popDat_URL))), sep = "\t", fill = T, stringsAsFactors = F, col.names = c("sample", "population", "superpop", "sex"), nThread = 4)
usethis::use_data(popDat_1KGphase3, overwrite  =  TRUE)
}
}
\usage{
data("popDat_1KGphase3")
}
\description{
Individual-level metadata for 1000 Genomes Project (Phase 3).
}
\seealso{
Other LD: 
\code{\link{check_population_1kg}()},
\code{\link{compute_LD}()},
\code{\link{filter_LD}()},
\code{\link{get_LD}()},
\code{\link{get_LD_1KG}()},
\code{\link{get_LD_1KG_download_vcf}()},
\code{\link{get_LD_UKB}()},
\code{\link{get_LD_matrix}()},
\code{\link{get_LD_vcf}()},
\code{\link{get_locus_vcf_folder}()},
\code{\link{ldlinkr_ldproxy_batch}()},
\code{\link{plot_LD}()},
\code{\link{popDat_1KGphase1}},
\code{\link{rds_to_npz}()},
\code{\link{saveSparse}()},
\code{\link{save_LD_matrix}()},
\code{\link{snpstats_get_MAF}()}
}
\concept{LD}
\keyword{datasets}
