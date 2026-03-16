# Read LD matrix

Read in an LD matrix stored in a variety of file formats, and convert it
to a sprase matrix.

## Usage

``` r
readSparse(LD_path, as_sparse = TRUE, as_df = FALSE, verbose = TRUE, ...)
```

## Arguments

- LD_path:

  Path to LD matrix.

- as_sparse:

  Convert the LD matrix to a sparse matrix.

- as_df:

  Convert to the matrix to a
  [data.frame](https://rdrr.io/r/base/data.frame.html).

- verbose:

  Print messages.

- ...:

  Arguments passed on to
  [`downloadR::load_rdata`](https://rdrr.io/pkg/downloadR/man/load_rdata.html)

  `fileName`

  :   Name of the file to load.

## Examples

``` r
LD_path <- tempfile(fileext = ".csv")
utils::write.csv(echodata::BST1_LD_matrix,
                 file = LD_path,
                 row.names = TRUE)
ld_mat <- readSparse(LD_path = LD_path)
#> LD_reference identified as: table.
#> Converting obj to sparseMatrix.
```
