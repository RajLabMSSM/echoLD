# source_all

Source all files in a directory at once. Also loads selected libraries.

## Usage

``` r
source_all(path = "R/", pattern = "*.R$", packages = "dplyr")
```

## Arguments

- path:

  a character vector of full path names; the default corresponds to the
  working directory, [`getwd()`](https://rdrr.io/r/base/getwd.html).
  Tilde expansion (see
  [`path.expand`](https://rdrr.io/r/base/path.expand.html)) is
  performed. Missing values will be ignored. Elements with a marked
  encoding will be converted to the native encoding (and if that fails,
  considered non-existent).

- pattern:

  an optional [regular expression](https://rdrr.io/r/base/regex.html).
  Only file names which match the regular expression will be returned.
