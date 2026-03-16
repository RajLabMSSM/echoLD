# Get LD using snpStats package

Get LD using snpStats package

## Usage

``` r
compute_LD(
  ss,
  select_snps = NULL,
  stats = c("R"),
  symmetric = TRUE,
  depth = "max",
  as_sparse = TRUE,
  verbose = TRUE
)
```

## Source

[snpStats Bioconductor
page](https://www.bioconductor.org/packages/release/bioc/html/snpStats.html)
[LD
tutorial](https://www.bioconductor.org/packages/release/bioc/vignettes/snpStats/inst/doc/ld-vignette.pdf)

## Arguments

- stats:

  A character vector specifying the linkage disequilibrium measures to
  be calculated. This should contain one or more of the strings:
  `"LLR"`, `"OR"`, `"Q"`, `"Covar"`, `"D.prime"`, `"R.squared"`, ad
  `"R"`

- symmetric:

  When no `y` argument is supplied this argument controls the format of
  the output band matrices. If `TRUE`, symmetric matrices are returned
  and, otherwise, an upper triangular matrices are returned

- depth:

  When `y` is not supplied, this parameter is mandatory and controls the
  maximum lag between columns of `x` considered. Thus, LD statistics are
  calculated between `x[,i]` and `x[,j]` only if `i` and `j` differ by
  no more than `depth`

## See also

Other LD:
[`check_population_1kg()`](https://rajlabmssm.github.io/echoLD/reference/check_population_1kg.md),
[`filter_LD()`](https://rajlabmssm.github.io/echoLD/reference/filter_LD.md),
[`get_LD()`](https://rajlabmssm.github.io/echoLD/reference/get_LD.md),
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
