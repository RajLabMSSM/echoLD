# Convert r² to r, and vice versa

Infers which LD correlation metric the `LD_matrix` currently contains,
and converts it to the requested LD correlation metric. **NOTE:** Since
+/- valence cannot be recovered from an r² matrix, r² can only be
converted to *absolute* r.

## Usage

``` r
r2_to_r(LD_matrix, LD_path = "", stats = "R", verbose = TRUE)
```

## Arguments

- LD_matrix:

  LD matrix.

- LD_path:

  \[Optional\] Path where LD matrix is stored. This is used to determine
  whether the matrix has already been converted to absolute r based on
  the presence of the "rAbsolute" substring (to avoid taking the square
  root twice).

- stats:

  The linkage disequilibrium measure to be calculated. Can be `"R"`
  (default) or `"R.squared"`.

- verbose:

  Print messages.

## Value

Named list containing the LD matrix and which LD metric is has been
formatted to.

## Examples

``` r
LD_matrix <- echodata::BST1_LD_matrix
r2r_out <- r2_to_r(LD_matrix = LD_matrix)
#> Checking LD metric (r/r2).
```
