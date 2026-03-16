# Download VCF subset from 1000 Genomes

Query the 1000 Genomes Project for a subset of their individual-level
VCF files.

## Usage

``` r
get_LD_1KG_download_vcf(
  query_granges,
  query_genome = "hg19",
  LD_reference = "1KGphase1",
  superpopulation = NULL,
  samples = character(0),
  local_storage = NULL,
  locus_dir = tempdir(),
  save_path = echotabix::construct_vcf_path(locus_dir = locus_dir, subdir = "LD",
    target_path = LD_reference, query_granges = query_granges),
  query_save = TRUE,
  force_new = FALSE,
  conda_env = "echoR_mini",
  nThread = 1,
  verbose = TRUE
)
```

## Source

` query_dat <- echodata::BST1 locus_dir <- file.path(tempdir(), echodata::locus_dir) query_granges <- echotabix::construct_query(query_dat=query_dat) vcf_subset.popDat <- echoLD:::get_LD_1KG_download_vcf( query_granges = query_granges, LD_reference = "1KGphase1", locus_dir = locus_dir) `

## Arguments

- query_granges:

  [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
  object to be used for querying the `target_path` file. Alternatively,
  can be variant-level summary statistics to be converted into a
  [GRanges](https://rdrr.io/pkg/GenomicRanges/man/GRanges-class.html)
  object by
  [construct_query](https://rdrr.io/pkg/echotabix/man/construct_query.html).

- query_genome:

  Genome build of the `query_dat`.

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

- local_storage:

  Storage folder for previously downloaded LD files. If `LD_reference`
  is "1KGphase1" or "1KGphase3", `local_storage` is where VCF files are
  stored. If `LD_reference` is "UKB", `local_storage` is where LD
  compressed numpy array (npz) files are stored. Set to `NULL` to
  download VCFs/LD npz from remote storage system.

- locus_dir:

  Storage directory to use.

- save_path:

  Path to save LD subset to.

- query_save:

  Whether to save the queried data subset.

- conda_env:

  Conda environment to use.

- nThread:

  Number of threads to parallelise across (when applicable).

- verbose:

  Print messages.

## See also

Other LD:
[`check_population_1kg()`](https://rajlabmssm.github.io/echoLD/reference/check_population_1kg.md),
[`compute_LD()`](https://rajlabmssm.github.io/echoLD/reference/compute_LD.md),
[`filter_LD()`](https://rajlabmssm.github.io/echoLD/reference/filter_LD.md),
[`get_LD()`](https://rajlabmssm.github.io/echoLD/reference/get_LD.md),
[`get_LD_1KG()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_1KG.md),
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
