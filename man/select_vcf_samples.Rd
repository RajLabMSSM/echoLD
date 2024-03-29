% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/select_vcf_samples.R
\name{select_vcf_samples}
\alias{select_vcf_samples}
\title{Subset VCF samples}
\usage{
select_vcf_samples(
  superpopulation = NULL,
  samples = NULL,
  LD_reference = "1KGphase1",
  verbose = TRUE
)
}
\arguments{
\item{superpopulation}{Superpopulation to subset LD panel by
(used only if \code{LD_reference} is "1KGphase1" or "1KGphase3").
See \link[echoLD]{popDat_1KGphase1} and \link[echoLD]{popDat_1KGphase3}
for full tables of their respective samples.}

\item{samples}{[Optional] Sample names to subset the VCF by. 
If this option is used, the \link[GenomicRanges]{GRanges} object will be
converted to a \link[VariantAnnotation]{ScanVcfParam} for usage by 
\link[VariantAnnotation]{readVcf}.}

\item{LD_reference}{LD reference to use:
\itemize{
\item{"1KGphase1" : }{1000 Genomes Project Phase 1 (genome build: hg19).}
\item{"1KGphase3" : }{1000 Genomes Project Phase 3 (genome build: hg19).}
\item{"UKB" : }{Pre-computed LD from a British
European-decent subset of UK Biobank.
\emph{Genome build} : hg19}
\item{"<vcf_path>" : }{User-supplied path to a custom VCF file 
to compute LD matrix from.\cr
\emph{Accepted formats}: \emph{.vcf} / \emph{.vcf.gz} / \emph{.vcf.bgz}\cr
\emph{Genome build} : defined by user with \code{target_genome}.}
\item{"<matrix_path>" : }{User-supplied path to a pre-computed LD matrix   
\emph{Accepted formats}:  \emph{.rds} / \emph{.rda} / \emph{.csv} / 
\emph{.tsv} / \emph{.txt}\cr
\emph{Genome build} : defined by user with \code{target_genome}.}
}}

\item{verbose}{Print messages.}
}
\description{
Subsrt VCF samples by superpopulation.
}
