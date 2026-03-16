# Get MAF from UK Biobank.

If **MAF** column is missing, download MAF from UK Biobank and use that
instead.

## Usage

``` r
get_MAF_UKB(
  query_dat,
  output_dir = tools::R_user_dir(package = "echoLD", which = "cache"),
  force_new_maf = FALSE,
  download_method = "axel",
  nThread = 1,
  verbose = TRUE,
  conda_env = "echoR_mini"
)
```

## Source

[UKB](http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=22801)

## Arguments

- query_dat:

  SNP-level data.

- output_dir:

  Path to store UKB_MAF file in.

- force_new_maf:

  Download UKB_MAF file again.

- download_method:

  Download method to use:

  `"axel"`

  :   Multi-threaded

  `"wget"`

  :   Single-threaded

  `"download.file"`

  :   Single-threaded

  `"internal"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

  `"wininet"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

  `"libcurl"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

  `"curl"`

  :   Single-threaded (passed to
      [download.file](https://rdrr.io/r/utils/download.file.html))

- nThread:

  Number of threads to parallelize over.

- verbose:

  Print messages.

- conda_env:

  Conda environment to use.

## Examples

``` r
if (FALSE) { # \dontrun{
query_dat<- echodata::BST1
query_dat$MAF <- NULL
dat2 <- echoLD::get_MAF_UKB(query_dat = query_dat)
} # }
```
