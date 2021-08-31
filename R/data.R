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
#' \href{https://www.biorxiv.org/content/10.1101/388165v3}{Nalls2019}
#'
#' @source
#' \code{
#' root_dir <- "~/Desktop/Fine_Mapping/Data/GWAS/Nalls23andMe_2019/BST1/Multi-finemap"
#' BST1 <- data.table::fread(file.path(root_dir, "Multi-finemap_results.txt"))
#' BST1 <- update_cols(dat = BST1)
#' BST1 <- find_consensus_SNPs(dat = BST1)
#' usethis::use_data(BST1, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("BST1")
"BST1"


#' Example results path for BST1 locus
#'
#' @source
#' \code{
#' locus_dir <- "results/GWAS/Nalls23andMe_2019/BST1"
#' usethis::use_data(locus_dir, overwrite = T)
#' }
#' @format path string
#' @usage data("locus_dir")
"locus_dir"


#' LD with the lead SNP: BST1 locus
#'
#' Precomputed LD within the \emph{BST1} locus
#'  (defined in \code{\link[=BST1]{BST1}}.
#' LD derived British, European-decent subpopulation in the UK Biobank.
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
#'
#' \href{https://www.ukbiobank.ac.uk}{UK Biobank}
#' \href{https://www.biorxiv.org/content/10.1101/807792v3}{Nalls 2019}
#'
#' @source
#' \code{
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
#' @format matrix
#' @usage data("BST1_LD_matrix")
"BST1_LD_matrix"


#' Population metadata: 1KGphase1
#'
#' Individual-level metadata for 1000 Genomes Project (Phase 1).
#'
#' @family LD
#' @source
#' \code{
#' popDat_URL <- "ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20110521/phase1_integrated_calls.20101123.ALL.panel"
#' popDat_1KGphase1 <- data.table::fread(text = trimws(gsub(",\t", ",", readLines(popDat_URL))), sep = "\t", fill = T, stringsAsFactors = F, col.names = c("sample", "population", "superpop", "sex"), nThread = 4)
#' usethis::use_data(popDat_1KGphase1, overwrite = T)
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
#' usethis::use_data(popDat_1KGphase3, overwrite = T)
#' }
#' @format data.table
#' @usage data("popDat_1KGphase3")
"popDat_1KGphase3"
