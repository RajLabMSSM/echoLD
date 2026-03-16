# Get LD blocks

Identify the LD block in which the lead SNP resides.

## Usage

``` r
get_LD_blocks(
  query_dat,
  ss,
  stats = c("R.squared", "D.prime"),
  pct = 0.15,
  verbose = TRUE
)
```

## Source

[adjclust GitHub](https://github.com/pneuvial/adjclust)

## Arguments

- query_dat:

  SNP-level data table.

- ss:

  snpStats object or LD matrix containing r or r² values.

- stats:

  Character vector of LD statistics to compute. Passed to
  [`snpClust`](https://pneuvial.github.io/adjclust/reference/snpClust.html).

- pct:

  Numeric. Percentage of the maximum number of clusters to select.
  Passed to
  [`select`](https://pneuvial.github.io/adjclust/reference/select.html).

- verbose:

  Print messages.

## Value

A list with the input data and LD matrix (r²).
