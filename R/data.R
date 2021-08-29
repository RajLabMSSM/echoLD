#' \pkg{echolocatoR} output example: BST1 locus
#'
#' An example results file after running
#' \code{finemap_loci} on the \emph{BST1} locus.
#'
#' Data originally comes from the Parkinson's disease GWAS
#' by \href{https://www.biorxiv.org/content/10.1101/388165v3}{Nalls et al., (bioRxiv)}.
#'
#' @format data.table
#' \describe{
#'   \item{SNP}{SNP RSID}
#'   \item{CHR}{Chromosome}
#'   \item{POS}{Genomic position (in basepairs)}
#'   \item{...}{Optional: extra columns}
#' }
#' @source \url{https://www.biorxiv.org/content/10.1101/388165v3}
#' @examples
#' \dontrun{
#' root_dir <- "~/Desktop/Fine_Mapping/Data/GWAS/Nalls23andMe_2019/BST1/Multi-finemap"
#' BST1 <- data.table::fread(file.path(root_dir, "Multi-finemap_results.txt"))
#' BST1 <- update_cols(finemap_dat = BST1)
#' BST1 <- find_consensus_SNPs(finemap_dat = BST1)
#' usethis::use_data(BST1, overwrite = T)
#' }
"BST1"


#' \pkg{echolocatoR} output example: LRRK2 locus
#'
#' An example results file after running
#' \code{\link[=finemap_loci]{finemap_loci()}} on the \emph{LRRK2} locus.
#'
#' Data originally comes from the Parkinson's disease GWAS
#' by \href{https://www.biorxiv.org/content/10.1101/388165v3}{Nalls et al. (bioRxiv)}.
#'
#' @format data.table
#' \describe{
#'   \item{SNP}{SNP RSID}
#'   \item{CHR}{Chromosome}
#'   \item{POS}{Genomic position (in basepairs)}
#'   \item{...}{Optional: extra columns}
#' }
#' @source \url{https://www.biorxiv.org/content/10.1101/388165v3}
#' @examples
#' \dontrun{
#' root_dir <- "~/Desktop/Fine_Mapping/Data/GWAS/Nalls23andMe_2019/LRRK2/Multi-finemap"
#' LRRK2 <- data.table::fread(file.path(root_dir, "Multi-finemap_results.txt"))
#' LRRK2 <- update_cols(finemap_dat = LRRK2)
#' LRRK2 <- find_consensus_SNPs(finemap_dat = LRRK2)
#' usethis::use_data(LRRK2, overwrite = T)
#' }
"LRRK2"


#' \emph{echolocatoR} output example: MEX3C locus
#'
#' An example results file after running
#' \code{\link[=finemap_loci]{finemap_loci()}} on the \emph{MEX3C} locus.
#'
#' Data originally comes from the Parkinson's disease GWAS
#' by \href{https://www.biorxiv.org/content/10.1101/388165v3}{Nalls et al. (bioRxiv)}.
#'
#' @format data.table
#' \describe{
#'   \item{SNP}{SNP RSID}
#'   \item{CHR}{Chromosome}
#'   \item{POS}{Genomic position (in basepairs)}
#'   \item{...}{Optional: extra columns}
#' }
#' @source \url{https://www.biorxiv.org/content/10.1101/388165v3}
#' @examples
#' \dontrun{
#' root_dir <- "~/Desktop/Fine_Mapping/Data/GWAS/Nalls23andMe_2019/MEX3C/Multi-finemap"
#' MEX3C <- data.table::fread(file.path(root_dir, "Multi-finemap_results.txt"))
#' MEX3C <- update_cols(finemap_dat = MEX3C)
#' MEX3C <- find_consensus_SNPs(finemap_dat = MEX3C)
#' usethis::use_data(MEX3C, overwrite = T)
#' }
"MEX3C"


#' Example results path for BST1 locus
#' @examples
#' \dontrun{
#' locus_dir <- "results/GWAS/Nalls23andMe_2019/BST1"
#' usethis::use_data(locus_dir, overwrite = T)
#' }
"locus_dir"


#' Example results path for genome-wide results
#' @examples
#' \dontrun{
#' genome_wide_dir <- "results/GWAS/Nalls23andMe_2019/_genome_wide"
#' usethis::use_data(genome_wide_dir, overwrite = T)
#' }
"genome_wide_dir"


#' LD with the lead SNP: BST1 locus
#'
#' Precomputed LD within the \emph{BST1} locus
#'  (defined in \code{\link[=BST1]{BST1}}.
#' LD derived white British subpopulation in the UK Biobank.
#' Only includes a subset of all the SNPs for storage purposes
#' (including the lead GWAS/QTL SNP).
#'
#' Data originally comes from \href{https://www.ukbiobank.ac.uk}{UK Biobank}.
#' LD was pre-computed and stored by the Alkes Price lab
#' (see \href{https://www.biorxiv.org/content/10.1101/807792v3}{here}).
#'
#' @format data.table
#' \describe{
#'   \item{SNP}{SNP RSID}
#'   \item{CHR}{Chromosome}
#'   \item{POS}{Genomic position (in basepairs)}
#'   \item{...}{Optional: extra columns}
#' }
#' @source
#' \url{https://www.ukbiobank.ac.uk}
#' \url{https://www.biorxiv.org/content/10.1101/807792v3}
#' @examples
#' \dontrun{
#' data("BST1")
#' finemap_DT <- BST1
#' # Only including a small subset of the full
#' # LD matrix for storage purposes.
#' lead_snp <- subset(finemap_DT, leadSNP)$SNP
#' snp_list <- finemap_DT[which(finemap_DT$SNP == lead_snp) - 100:which(finemap_DT$SNP == lead_snp) + 100, ]$SNP
#' BST1_LD_matrix <- readRDS("../Fine_Mapping/Data/GWAS/Nalls23andMe_2019/BST1/plink/UKB_LD.RDS")
#' BST1_LD_matrix <- BST1_LD_matrix[snp_list, snp_list]
#' usethis::use_data(BST1_LD_matrix, overwrite = T)
#' }
"BST1_LD_matrix"


#' Population metadata: 1KGphase1
#'
#' @family LD
#' @examples
#' \dontrun{
#' popDat_URL <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/phase1_integrated_calls.20101123.ALL.panel"
#' popDat_1KGphase1 <- data.table::fread(text = trimws(gsub(",\t", ",", readLines(popDat_URL))), sep = "\t", fill = T, stringsAsFactors = F, col.names = c("sample", "population", "superpop", "sex"), nThread = 4)
#' usethis::use_data(popDat_1KGphase1, overwrite = T)
#' }
"popDat_1KGphase1"


#' Population metadata: 1KGphase3
#'
#' @family LD
#' @examples
#' \dontrun{
#' popDat_URL <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel"
#' popDat_1KGphase3 <- data.table::fread(text = trimws(gsub(",\t", ",", readLines(popDat_URL))), sep = "\t", fill = T, stringsAsFactors = F, col.names = c("sample", "population", "superpop", "sex"), nThread = 4)
#' usethis::use_data(popDat_1KGphase3, overwrite = T)
#' }
"popDat_1KGphase3"
