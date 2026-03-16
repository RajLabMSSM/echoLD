# Convert to sparse

Convert a [matrix](https://rdrr.io/r/base/matrix.html) /
[data.frame](https://rdrr.io/r/base/data.frame.html) to a sparse matrix.
If `X` is already a sparse matrix, it simply returns `X` directly.

## Usage

``` r
to_sparse(X, verbose = TRUE)
```

## Arguments

- X:

  A [matrix](https://rdrr.io/r/base/matrix.html) /
  [data.frame](https://rdrr.io/r/base/data.frame.html).

- verbose:

  Print messages.

## Value

Sparse matrix.

## Examples

``` r
mat <- to_sparse(X = mtcars)
#> Converting obj to sparseMatrix.
```
