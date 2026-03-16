# Plot a subset of the LD matrix

Plot a heatmap of pairwise LD between SNPs.

## Usage

``` r
plot_LD(
  LD_matrix,
  query_dat,
  span = 10,
  method = c("stats", "gaston", "graphics"),
  ...
)
```

## Arguments

- LD_matrix:

  LD matrix.

- query_dat:

  SNP-level summary statistics subset to query the LD panel with.

- span:

  This is very computationally intensive, so you need to limit the
  number of SNPs with span. If `span=10`, only 10 SNPs upstream and 10
  SNPs downstream of the lead SNP will be plotted.

- method:

  Method to use for plotting:

  stats

  :   [heatmap](https://rdrr.io/r/stats/heatmap.html)

  gaston

  :   [LD.plot](https://rdrr.io/pkg/gaston/man/LD.plot.html)

  graphics

  :   [image](https://rdrr.io/r/graphics/image.html)

- ...:

  Additional arguments passed to plotting function.

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
[`get_LD_vcf()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_vcf.md),
[`get_locus_vcf_folder()`](https://rajlabmssm.github.io/echoLD/reference/get_locus_vcf_folder.md),
[`ldlinkr_ldproxy_batch()`](https://rajlabmssm.github.io/echoLD/reference/ldlinkr_ldproxy_batch.md),
[`popDat_1KGphase1`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase1.md),
[`popDat_1KGphase3`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase3.md),
[`rds_to_npz()`](https://rajlabmssm.github.io/echoLD/reference/rds_to_npz.md),
[`saveSparse()`](https://rajlabmssm.github.io/echoLD/reference/saveSparse.md),
[`save_LD_matrix()`](https://rajlabmssm.github.io/echoLD/reference/save_LD_matrix.md),
[`snpstats_get_MAF()`](https://rajlabmssm.github.io/echoLD/reference/snpstats_get_MAF.md)

## Examples

``` r
query_dat<- echodata::BST1
LD_matrix <- echodata::BST1_LD_matrix
echoLD::plot_LD(LD_matrix = LD_matrix,
                query_dat= query_dat)
```
