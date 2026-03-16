# Save LD matrix

Save an LD matrix after initial pre-processing.

## Usage

``` r
save_LD_matrix(
  LD_matrix,
  dat,
  locus_dir,
  fillNA = 0,
  LD_reference,
  subset_common = TRUE,
  as_sparse = TRUE,
  verbose = TRUE
)
```

## Source

` dat <- echodata::BST1 LD_matrix <- echodata::BST1_LD_matrix locus_dir <- file.path(tempdir(),echodata::locus_dir) LD_list <- echoLD:::save_LD_matrix( LD_matrix = LD_matrix, dat = dat locus_dir = locus_dir, LD_reference = "UKB") LD_list <- echoLD:::save_LD_matrix( LD_matrix = LD_matrix, dat = dat locus_dir = locus_dir, LD_reference = "custom_vcf") `

## Arguments

- locus_dir:

  Storage directory to use.

- fillNA:

  Value to fill LD matrix NAs with.

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

- subset_common:

  Subset `LD_matrix` and `dat` to only the SNPs that are common to them
  both.

- as_sparse:

  Convert the LD matrix to a sparse matrix.

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
[`get_LD_vcf()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_vcf.md),
[`get_locus_vcf_folder()`](https://rajlabmssm.github.io/echoLD/reference/get_locus_vcf_folder.md),
[`ldlinkr_ldproxy_batch()`](https://rajlabmssm.github.io/echoLD/reference/ldlinkr_ldproxy_batch.md),
[`plot_LD()`](https://rajlabmssm.github.io/echoLD/reference/plot_LD.md),
[`popDat_1KGphase1`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase1.md),
[`popDat_1KGphase3`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase3.md),
[`rds_to_npz()`](https://rajlabmssm.github.io/echoLD/reference/rds_to_npz.md),
[`saveSparse()`](https://rajlabmssm.github.io/echoLD/reference/saveSparse.md),
[`snpstats_get_MAF()`](https://rajlabmssm.github.io/echoLD/reference/snpstats_get_MAF.md)
