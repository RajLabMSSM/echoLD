# Download UKB LD

Download UK Biobank Linkage Disequilibrium, pre-computed in 3Mb windows
by the Alkes Price lab (Broad Institute).

## Usage

``` r
download_UKB_LD(
  LD.prefixes,
  locus_dir,
  bucket = "s3://broad-alkesgroup-ukbb-ld/",
  background = TRUE,
  force_overwrite = FALSE,
  nThread = 1,
  verbose = TRUE,
  ...
)
```

## Arguments

- locus_dir:

  Storage directory to use.

- bucket:

  Character string with the name of the bucket, or an object of class
  “s3_bucket”.

- force_overwrite:

  Overwrite existing file.

- nThread:

  Number of threads to parallelise across (when applicable).

- verbose:

  Print messages.

- ...:

  Arguments passed on to
  [`downloadR::aws`](https://rdrr.io/pkg/downloadR/man/aws.html)

  `input_url`

  :   URL to remote file.

  `output_path`

  :   The file name you want to save the download as.
