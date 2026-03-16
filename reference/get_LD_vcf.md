# Compute LD from VCF file

Imports a subset of a local or remote VCF file that matches your locus
coordinates. Then uses [ld](https://rdrr.io/pkg/snpStats/man/ld.html) to
calculate LD on the fly.

## Usage

``` r
get_LD_vcf(
  locus_dir = tempdir(),
  query_dat,
  LD_reference,
  query_genome = "hg19",
  target_genome = "hg19",
  superpopulation = NULL,
  samples = NULL,
  overlapping_only = TRUE,
  leadSNP_LD_block = FALSE,
  force_new = FALSE,
  force_new_maf = FALSE,
  fillNA = 0,
  stats = "R",
  as_sparse = TRUE,
  subset_common = TRUE,
  remove_tmps = TRUE,
  nThread = 1,
  conda_env = "echoR_mini",
  verbose = TRUE
)
```

## Arguments

- locus_dir:

  Storage directory to use.

- query_dat:

  SNP-level summary statistics subset to query the LD panel with.

- LD_reference:

  LD reference to use:

  1KGphase1

  :   1000 Genomes Project Phase 1 (genome build: hg19).

  1KGphase3

  :   1000 Genomes Project Phase 3 (genome build: hg19).

  UKB

  :   Pre-computed LD from a British European-decent subset of UK
      Biobank. *Genome build* : hg19

  \<vcf_path\>

  :   User-supplied path to a custom VCF file to compute LD matrix
      from.\
      *Accepted formats*: *.vcf* / *.vcf.gz* / *.vcf.bgz*\
      *Genome build* : defined by user with `target_genome`.

  \<matrix_path\>

  :   User-supplied path to a pre-computed LD matrix. *Accepted
      formats*: *.rds* / *.rda* / *.csv* / *.tsv* / *.txt*\
      *Genome build* : defined by user with `target_genome`.

- query_genome:

  Genome build of the `query_dat`.

- target_genome:

  Genome build of the LD panel. This is automatically assigned to the
  correct genome build for each LD panel except when the user supplies
  custom vcf/LD files.

- superpopulation:

  Superpopulation to subset LD panel by (used only if `LD_reference` is
  "1KGphase1" or "1KGphase3"). See
  [popDat_1KGphase1](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase1.md)
  and
  [popDat_1KGphase3](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase3.md)
  for full tables of their respective samples.

- samples:

  \[Optional\] Sample names to subset the VCF by. If this option is
  used, the
  [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
  object will be converted to a
  [ScanVcfParam](https://rdrr.io/pkg/VariantAnnotation/man/ScanVcfParam-class.html)
  for usage by
  [readVcf](https://rdrr.io/pkg/VariantAnnotation/man/readVcf-methods.html).

- overlapping_only:

  Remove variants that do not overlap with the positions in `query_dat`.

- leadSNP_LD_block:

  Only return SNPs within the same LD block as the lead SNP (the SNP
  with the smallest p-value).

- force_new:

  Force the creation of a new VCF subset file even if one exists.

- force_new_maf:

  Download UKB_MAF file again.

- fillNA:

  When pairwise LD between two SNPs is `NA`, replace with 0.

- stats:

  LD stats to r

- as_sparse:

  Convert the LD matrix to a sparse matrix.

- subset_common:

  Subset `LD_matrix` and `dat` to only the SNPs that are common to them
  both.

- remove_tmps:

  Remove all intermediate files like *vcf*, *npz*, and *plink* files.

- nThread:

  Number of threads to parallelise across (when applicable).

- conda_env:

  Conda environment to use.

- verbose:

  Print messages.

## See also

Other LD:
[`check_population_1kg()`](https://rajlabmssm.github.io/echoLD/reference/check_population_1kg.md),
[`compute_LD()`](https://rajlabmssm.github.io/echoLD/reference/compute_LD.md),
[`filter_LD()`](https://rajlabmssm.github.io/echoLD/reference/filter_LD.md),
[`get_LD()`](https://rajlabmssm.github.io/echoLD/reference/get_LD.md),
[`get_LD_1KG()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_1KG.md),
[`get_LD_1KG_download_vcf()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_1KG_download_vcf.md),
[`get_LD_UKB()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_UKB.md),
[`get_LD_matrix()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_matrix.md),
[`get_locus_vcf_folder()`](https://rajlabmssm.github.io/echoLD/reference/get_locus_vcf_folder.md),
[`ldlinkr_ldproxy_batch()`](https://rajlabmssm.github.io/echoLD/reference/ldlinkr_ldproxy_batch.md),
[`plot_LD()`](https://rajlabmssm.github.io/echoLD/reference/plot_LD.md),
[`popDat_1KGphase1`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase1.md),
[`popDat_1KGphase3`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase3.md),
[`rds_to_npz()`](https://rajlabmssm.github.io/echoLD/reference/rds_to_npz.md),
[`saveSparse()`](https://rajlabmssm.github.io/echoLD/reference/saveSparse.md),
[`save_LD_matrix()`](https://rajlabmssm.github.io/echoLD/reference/save_LD_matrix.md),
[`snpstats_get_MAF()`](https://rajlabmssm.github.io/echoLD/reference/snpstats_get_MAF.md)

## Examples

``` r
if (FALSE) { # \dontrun{
query_dat <-  echodata::BST1[seq(1, 50), ]
locus_dir <- echodata::locus_dir
locus_dir <- file.path(tempdir(), locus_dir)
LD_reference <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
    package = "echodata"
)
LD_list <- get_LD_vcf(
    locus_dir = locus_dir,
    query_dat = query_dat,
    LD_reference = LD_reference)
} # }
```
