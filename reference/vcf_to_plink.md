# Convert VCF to PLINK

Convert a Variant Call File (VCF) to
[PLINK](https://www.cog-genomics.org/plink/) format.

## Usage

``` r
vcf_to_plink(
  vcf,
  output_prefix = NULL,
  bcftools_path = NULL,
  make_bed = TRUE,
  recode = TRUE,
  verbose = TRUE
)
```

## Arguments

- vcf:

  Specify full name of .vcf or .vcf.gz file.

- output_prefix:

  Specify prefix for output files.

- bcftools_path:

  Path to `bedtools` executable. If `NULL`, will automatically be
  downloaded with
  [find_executables_remote](https://rdrr.io/pkg/echoconda/man/find_executables_remote.html).

- make_bed:

  Create a new binary fileset. Unlike the automatic text-to-binary
  converters (which only heed chromosome filters), this supports all of
  PLINK's filtering flags.

- recode:

  Create a new text fileset with all filters applied.

- verbose:

  Print messages.

## Examples

``` r
if (FALSE) { # \dontrun{
vcf <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
    package = "echodata")
paths <- vcf_to_plink(vcf = vcf)
} # }
```
