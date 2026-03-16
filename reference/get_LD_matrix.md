# Get LD from pre-computed matrix

Get LD from a pre-computed matrix of pairwise r / r²values.

## Usage

``` r
get_LD_matrix(
  locus_dir = tempdir(),
  query_dat,
  LD_reference,
  query_genome = "hg19",
  target_genome = "hg19",
  fillNA = 0,
  stats = "R",
  as_sparse = TRUE,
  subset_common = TRUE,
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

- fillNA:

  When pairwise LD between two SNPs is `NA`, replace with 0.

- stats:

  The linkage disequilibrium measure to be calculated. Can be `"R"`
  (default) or `"R.squared"`.

- as_sparse:

  Convert the LD matrix to a sparse matrix.

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
[`get_LD_UKB()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_UKB.md),
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
query_dat <-  echodata::BST1[seq(1, 50), ] 
locus_dir <- file.path(tempdir(),  echodata::locus_dir)
LD_reference <- tempfile(fileext = ".csv")
utils::write.csv(echodata::BST1_LD_matrix,
                 file = LD_reference,
                 row.names = TRUE)
LD_list <- get_LD_matrix(
    locus_dir = locus_dir,
    query_dat = query_dat,
    LD_reference = LD_reference)
#> Using custom VCF as LD reference panel.
#> Previously computed LD_matrix detected. Importing: /tmp/Rtmpyv53td/file5f9f2e577143.csv
#> LD_reference identified as: table.
#> Converting obj to sparseMatrix.
#> Checking LD metric (r/r2).
#> 45 x 45 LD_matrix (sparse)
#> Converting obj to sparseMatrix.
#> Saving sparse LD matrix ==> /tmp/Rtmpyv53td/results/GWAS/Nalls23andMe_2019/BST1/LD/BST1.custom_r_LD.RDS
```
