# Subset LD matrix and dataframe to only their shared SNPs

Find the SNPs that are shared between an LD matrix and another
data.frame with a "SNP" column. Then remove any non-shared SNPs from
both objects.

## Usage

``` r
subset_common_snps(
  LD_matrix,
  dat,
  fillNA = 0,
  as_sparse = TRUE,
  verbose = FALSE
)
```

## Arguments

- LD_matrix:

  LD matrix.

- dat:

  SNP-level summary statistics subset to query the LD panel with.

- fillNA:

  Value to fill LD matrix NAs with.

- as_sparse:

  Convert `LD_matrix` to sparse matrix before returning.

- verbose:

  Print messages.

## Value

data.frame

## Examples

``` r
out <- echoLD::subset_common_snps(LD_matrix = echodata::BST1_LD_matrix,
                                  dat = echodata::BST1)
```
