# Fill NAs in an LD matrix

Trickier than it looks.

## Usage

``` r
fill_NA(LD_matrix, fillNA = 0, verbose = FALSE)
```

## Arguments

- LD_matrix:

  LD matrix

- fillNA:

  Fill all NAs in the `LD_matrix` with `fillNA` value.

- verbose:

  Print messages.

## Details

` BST1_LD_matrix <- echodata::BST1_LD_matrix LD_matrix <- echodata:::fill_NA(BST1_LD_matrix) `
