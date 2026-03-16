# Extract LD proxies from 1KGphase3

Wrapper for
[`LDlinkR::LDproxy_batch`](https://rdrr.io/pkg/LDlinkR/man/LDproxy_batch.html).
Easy to use but doesn't scale up well to many SNPs (takes way too long).

## Usage

``` r
ldlinkr_ldproxy_batch(
  snp,
  pop = "CEU",
  r2d = "r2",
  min_corr = FALSE,
  save_dir = NULL,
  verbose = TRUE
)
```

## Source

[website](https://www.rdocumentation.org/packages/LDlinkR/versions/1.0.2)

## Arguments

- snp:

  a character string or data frame listing rsID's or chromosome
  coordinates (e.g. "chr7:24966446"), one per line

- pop:

  a 1000 Genomes Project population, (e.g. YRI or CEU), multiple
  allowed, default = "CEU"

- r2d:

  either "r2" for LD R2 or "d" for LD D', default = "r2"

- min_corr:

  Minimum correlation with `snp`.

- save_dir:

  Save folder.

- verbose:

  Print messages.

## Details

` merged_query_dat <- echodata::get_Nalls2019_merged() lead.snps <- setNames(subset(merged_query_dat, leadSNP)$Locus, subset(merged_query_dat, leadSNP)$SNP) proxies <- ldlinkr_ldproxy_batch(snp = lead.snps) `

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
[`plot_LD()`](https://rajlabmssm.github.io/echoLD/reference/plot_LD.md),
[`popDat_1KGphase1`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase1.md),
[`popDat_1KGphase3`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase3.md),
[`rds_to_npz()`](https://rajlabmssm.github.io/echoLD/reference/rds_to_npz.md),
[`saveSparse()`](https://rajlabmssm.github.io/echoLD/reference/saveSparse.md),
[`save_LD_matrix()`](https://rajlabmssm.github.io/echoLD/reference/save_LD_matrix.md),
[`snpstats_get_MAF()`](https://rajlabmssm.github.io/echoLD/reference/snpstats_get_MAF.md)
