# echoLD 0.99.1

## New features

* Added more unit tests.  
* Exported:
    + `filter_LD`
    + `subset_common_snps`
    + `plot_LD`
* Moved Imports to Suggests:
    + `gaston`
    + `graphics` 
    + `LDlinkR`
    + `adjclust`
* `get_UKB_MAF`: Cached UKB MAF in `echoLD`-specific cache.  
* Moved majority of data to `echodata` package. 
* Convert LD to sparse by default. Only convert if not already sparse. 
* Remove codecov yaml. 
* Add CITATIONS file.
* Update README to use autofill. 
* Add hex sticker. 
* Remove *docs/*
* Updated GHA with latest ``templateR` workflow. 

# echoLD 0.99.0

## New features

* Added a `NEWS.md` file to track changes to the package.
* Utilises `echoannot` and `downloadR` packages. 
