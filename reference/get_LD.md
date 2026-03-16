# Procure an LD matrix for fine-mapping

Calculate and/or query linkage disequilibrium (LD) from reference panels
(UK Biobank, 1000 Genomes), a user-supplied pre-computed LD matrix. If
need be, `query_dat` will automatically be lifted over to the genome
build of the target LD panel before query is performed.

## Usage

``` r
get_LD(
  query_dat,
  locus_dir = tempdir(),
  standardise_colnames = FALSE,
  force_new_LD = FALSE,
  LD_reference = c("1KGphase1", "1KGphase3", "UKB"),
  query_genome = "hg19",
  target_genome = "hg19",
  samples = character(0),
  superpopulation = NULL,
  local_storage = NULL,
  leadSNP_LD_block = FALSE,
  fillNA = 0,
  verbose = TRUE,
  remove_tmps = TRUE,
  as_sparse = TRUE,
  subset_common = TRUE,
  download_method = "axel",
  conda_env = "echoR_mini",
  nThread = 1
)
```

## Arguments

- query_dat:

  SNP-level summary statistics subset to query the LD panel with.

- locus_dir:

  Storage directory to use.

- standardise_colnames:

  Automatically rename all columns to a standard nomenclature using
  [standardise_header](https://al-murphy.github.io/MungeSumstats/reference/standardise_header.html).

- force_new_LD:

  Force new LD subset.

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

- samples:

  \[Optional\] Sample names to subset the VCF by. If this option is
  used, the
  [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
  object will be converted to a
  [ScanVcfParam](https://rdrr.io/pkg/VariantAnnotation/man/ScanVcfParam-class.html)
  for usage by
  [readVcf](https://rdrr.io/pkg/VariantAnnotation/man/readVcf-methods.html).

- superpopulation:

  Superpopulation to subset LD panel by (used only if `LD_reference` is
  "1KGphase1" or "1KGphase3"). See
  [popDat_1KGphase1](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase1.md)
  and
  [popDat_1KGphase3](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase3.md)
  for full tables of their respective samples.

- local_storage:

  Storage folder for previously downloaded LD files. If `LD_reference`
  is "1KGphase1" or "1KGphase3", `local_storage` is where VCF files are
  stored. If `LD_reference` is "UKB", `local_storage` is where LD
  compressed numpy array (npz) files are stored. Set to `NULL` to
  download VCFs/LD npz from remote storage system.

- leadSNP_LD_block:

  Only return SNPs within the same LD block as the lead SNP (the SNP
  with the smallest p-value).

- fillNA:

  Value to fill LD matrix NAs with.

- verbose:

  Print messages.

- remove_tmps:

  Remove all intermediate files like *vcf*, *npz*, and *plink* files.

- as_sparse:

  Convert the LD matrix to a sparse matrix.

- subset_common:

  Subset `LD_matrix` and `dat` to only the SNPs that are common to them
  both.

- download_method:

  Download method to use:

  `"axel"`

  :   Multi-threaded

  `"wget"`

  :   Single-threaded

  `"download.file"`

  :   Single-threaded

  `"internal"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

  `"wininet"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

  `"libcurl"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

  `"curl"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

- conda_env:

  Conda environment to use.

- nThread:

  Number of threads to parallelise across (when applicable).

## Value

A named list containing:

- LD:

  Symmetric LD matrix of pairwise SNP correlations.

- DT:

  Standardised query data filtered to only the SNPs included in both
  `query_dat` and the LD matrix.

- path:

  The path to where the LD matrix was saved.

## See also

Other LD:
[`check_population_1kg()`](https://rajlabmssm.github.io/echoLD/reference/check_population_1kg.md),
[`compute_LD()`](https://rajlabmssm.github.io/echoLD/reference/compute_LD.md),
[`filter_LD()`](https://rajlabmssm.github.io/echoLD/reference/filter_LD.md),
[`get_LD_1KG()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_1KG.md),
[`get_LD_1KG_download_vcf()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_1KG_download_vcf.md),
[`get_LD_UKB()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_UKB.md),
[`get_LD_matrix()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_matrix.md),
[`get_LD_vcf()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_vcf.md),
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
query_dat <- echodata::BST1[seq(1, 50), ]
locus_dir <- file.path(tempdir(), echodata::locus_dir)
LD_list <- echoLD::get_LD(
    locus_dir = locus_dir,
    query_dat = query_dat,
    LD_reference = "1KGphase1")
} # }
```
