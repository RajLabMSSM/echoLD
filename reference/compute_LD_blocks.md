# Compute LD blocks

Compute LD blocks using
[snpClust](https://pneuvial.github.io/adjclust/reference/snpClust.html).

## Usage

``` r
compute_LD_blocks(
  x,
  stats = c("R.squared", "D.prime"),
  type = c("capushe", "bstick"),
  k.max = NULL,
  pct = 0.15,
  verbose = TRUE
)
```

## Source

[adjclust GitHub](https://github.com/pneuvial/adjclust)

## Arguments

- x:

  either a genotype matrix of class
  [`SnpMatrix`](https://rdrr.io/pkg/snpStats/man/SnpMatrix-class.html)/[`matrix`](https://rdrr.io/r/base/matrix.html)
  or a linkage disequilibrium matrix of class
  [`dgCMatrix`](https://rdrr.io/pkg/Matrix/man/dgCMatrix-class.html). In
  the latter case the LD values are expected to be in \[0,1\]

- stats:

  a character vector specifying the linkage disequilibrium measures to
  be calculated (using the
  [`ld`](https://rdrr.io/pkg/snpStats/man/ld.html) function) when `x` is
  a genotype matrix. Only "R.squared" and "D.prime" are allowed, see
  Details.

- type:

  model selection approach between slope heuristic (`"capushe"`) and
  broken stick approach (`"bstick"`)

- k.max:

  maximum number of clusters that can be selected. Default to `NULL`, in
  which case it is set to \\\min(\max(100, \frac{n}{\log(n)}),
  \frac{n}{2})\\ where \\n\\ is the number of objects to be clustered
  for capushe and to \\n\\ for the broken stick model

- pct:

  minimum percentage of points for the plateau selection in capushe
  selection. See [`DDSE`](https://rdrr.io/pkg/capushe/man/DDSE.html) for
  further details

- verbose:

  Print messages.
