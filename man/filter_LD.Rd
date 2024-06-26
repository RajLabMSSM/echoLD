% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_LD.R
\name{filter_LD}
\alias{filter_LD}
\title{Filter LD}
\usage{
filter_LD(LD_list, remove_correlates = FALSE, min_r2 = 0, verbose = FALSE)
}
\arguments{
\item{LD_list}{List containing SNP-level data (\code{dat}),
and LD matrix (\code{LD}).}

\item{remove_correlates}{A list of SNPs.
If provided, all SNPs that correlates with these SNPs (at r2>=\code{min_r2})
will be removed from both \code{dat} and \code{LD} list items..}

\item{min_r2}{Correlation threshold for \code{remove_correlates}.}

\item{verbose}{Print messages.}
}
\description{
Filter LD
}
\examples{
LD_list <- list(LD = echodata::BST1_LD_matrix,
                DT = echodata::BST1)
LD_list2 <- echoLD::filter_LD(LD_list = LD_list, min_r2 = .2)
}
\seealso{
Other LD: 
\code{\link{check_population_1kg}()},
\code{\link{compute_LD}()},
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
\code{\link{popDat_1KGphase3}},
\code{\link{rds_to_npz}()},
\code{\link{saveSparse}()},
\code{\link{save_LD_matrix}()},
\code{\link{snpstats_get_MAF}()}
}
\concept{LD}
