# Get LD with lead SNP

Add new columns r and r2 containing the degree of LD in each SNP (row)
with the lead GWAS/QTL SNP.

## Usage

``` r
get_lead_r2(
  dat,
  LD_matrix = NULL,
  fillNA = 0,
  LD_format = "matrix",
  verbose = TRUE
)
```

## Arguments

- dat:

  SNP-level data.

- LD_matrix:

  LD matrix.

- fillNA:

  Value to fill NAs with in r/r2 columns.

- LD_format:

  The format of the provided `LD_matrix`: "matrix" (wide) or "df"
  (long).

- verbose:

  Print messages.

## Value

[data.table](https://rdrr.io/pkg/data.table/man/data.table.html) with
the columns r and r2.

## Examples

``` r
dat2 <- echoLD::get_lead_r2(dat = echodata::BST1,
                            LD_matrix = echodata::BST1_LD_matrix)
#> LD_matrix detected. Coloring SNPs by LD with lead SNP.
#> Filling r/r2 NAs with 0
```
