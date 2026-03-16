# Download LD matrices from UK Biobank

Download pre-computed LD matrices from [UK
Biobank](https://www.ukbiobank.ac.uk) in 3Mb windows, then subset to the
region that overlaps with `query_dat`.\
\
LD was derived from a British, European-decent subpopulation in the UK
Biobank. LD was pre-computed and stored by the Alkes Price lab. All data
is aligned to the hg19 reference genome. For further details, see the
PolyFun publication
([doi:10.1038/s41588-020-00735-5](https://doi.org/10.1038/s41588-020-00735-5)
).

## Usage

``` r
get_LD_UKB(
  query_dat,
  query_genome = "hg19",
  locus_dir,
  chrom = NULL,
  min_pos = NULL,
  force_new_LD = FALSE,
  local_storage = NULL,
  download_full_ld = FALSE,
  download_method = "axel",
  fillNA = 0,
  nThread = 1,
  return_matrix = TRUE,
  as_sparse = TRUE,
  conda_env = "echoR_mini",
  remove_tmps = TRUE,
  subset_common = TRUE,
  verbose = TRUE
)
```

## Source

` query_dat <- data.table::data.table(CHR=10,POS=c(135000001), SNP="rs1234") locus_dir <- file.path(tempdir(), "locus_A") LD_list <- echoLD:::get_LD_UKB( query_dat = query_dat, locus_dir = locus_dir) `

## Arguments

- query_dat:

  SNP-level summary statistics subset to query the LD panel with.

- query_genome:

  Genome build of the `query_dat`.

- locus_dir:

  Storage directory to use.

- force_new_LD:

  Force new LD subset.

- local_storage:

  Path to folder with previously download LD npz files.

- download_method:

  If "python" will import compressed numpy array directly into R using
  reticulate. Otherwise, will be passed to
  [downloader](https://rdrr.io/pkg/downloadR/man/downloader.html) to
  download the full 3Mb-window LD matrix first.

- fillNA:

  Value to fill LD matrix NAs with.

- nThread:

  Number of threads to parallelise across (when applicable).

- as_sparse:

  Convert the LD matrix to a sparse matrix.

- conda_env:

  Conda environment to use.

- remove_tmps:

  Remove all intermediate files like *vcf*, *npz*, and *plink* files.

- subset_common:

  Subset `LD_matrix` and `dat` to only the SNPs that are common to them
  both.

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
