# echoLD 0.99.2

## New features

* Update to match changes in `echotabix`.
* Change to more consistent/intuitive function names:
    - `create_or_load` --> `get_LD`
    - `LD_ukbiobank` --> `get_LD_UKB`
    - `LD_1KG` --> `get_LD_1KG`
    - `LD_custom` --> `get_LD_custom`



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
