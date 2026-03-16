# Package index

## LD Retrieval

Retrieve LD matrices from reference panels or custom sources.

- [`get_LD()`](https://rajlabmssm.github.io/echoLD/reference/get_LD.md)
  : Procure an LD matrix for fine-mapping
- [`get_LD_matrix()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_matrix.md)
  : Get LD from pre-computed matrix
- [`get_LD_vcf()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_vcf.md)
  : Compute LD from VCF file

## LD Blocks

Identify and work with LD blocks.

- [`get_LD_blocks()`](https://rajlabmssm.github.io/echoLD/reference/get_LD_blocks.md)
  : Get LD blocks
- [`get_lead_r2()`](https://rajlabmssm.github.io/echoLD/reference/get_lead_r2.md)
  : Get LD with lead SNP

## LD Filtering and Conversion

Filter, convert, and transform LD matrices.

- [`filter_LD()`](https://rajlabmssm.github.io/echoLD/reference/filter_LD.md)
  : Filter LD

- [`r2_to_r()`](https://rajlabmssm.github.io/echoLD/reference/r2_to_r.md)
  :

  Convert r² to r, and vice versa

- [`subset_common_snps()`](https://rajlabmssm.github.io/echoLD/reference/subset_common_snps.md)
  : Subset LD matrix and dataframe to only their shared SNPs

## Sparse Matrix I/O

Read, write, and convert sparse LD matrices.

- [`readSparse()`](https://rajlabmssm.github.io/echoLD/reference/readSparse.md)
  : Read LD matrix
- [`saveSparse()`](https://rajlabmssm.github.io/echoLD/reference/saveSparse.md)
  : Save LD matrix as a sparse matrix
- [`to_sparse()`](https://rajlabmssm.github.io/echoLD/reference/to_sparse.md)
  : Convert to sparse

## Visualization

Plot LD matrices as heatmaps.

- [`plot_LD()`](https://rajlabmssm.github.io/echoLD/reference/plot_LD.md)
  : Plot a subset of the LD matrix

## VCF Utilities

VCF sample selection and format conversion.

- [`select_vcf_samples()`](https://rajlabmssm.github.io/echoLD/reference/select_vcf_samples.md)
  : Subset VCF samples
- [`vcf_to_plink()`](https://rajlabmssm.github.io/echoLD/reference/vcf_to_plink.md)
  : Convert VCF to PLINK

## Allele Frequencies

Minor allele frequency retrieval.

- [`get_MAF_UKB()`](https://rajlabmssm.github.io/echoLD/reference/get_MAF_UKB.md)
  : Get MAF from UK Biobank.

## Bundled data

- [`popDat_1KGphase1`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase1.md)
  : Population metadata: 1KGphase1
- [`popDat_1KGphase3`](https://rajlabmssm.github.io/echoLD/reference/popDat_1KGphase3.md)
  : Population metadata: 1KGphase3
