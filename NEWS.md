# echoLD 0.99.10

## New features 

* `get_LD`: pass up `subset_common` arg

## Bug fixes

* Fix UKB LD now that AlkesGroup moved data to AWS S3 bucket: #12

# echoLD 0.99.9

## New features 

* Implement `rworkflows`

# echoLD 0.99.8

## New features 

* `get_UKB_MAF` --> `get_MAF_UKB`
* `get_LD_UKB`:
    - New subfunction `load_ld_r``tryFun`: 
    - Remove `tryFun` function. 

## Bug fixes

* Added `echoconda` to *Remotes*: `github::RajLabMSSM/echoconda`
* Remote `GenomeInfoDb` Import (no longer used here).  
* Fix GHA: @master --> @v2  
* Fix `saveSparse` example. 
* Fix `filter_LD` unit test. 
* Fix `download_UKB_LD`: Update `downloadR::downloader` arg 
    from `output_path` --> `output_dir` 

# echoLD 0.99.7

## New features

- New function:
    - `vcf_to_plink`
- New exports:
    - `readSparse`
    - `saveSparse`
    - `get_LD_vcf`
    - `get_LD_matrix`
    - `r2_to_r`
    - `to_sparse`
- Enabled reading of pre-computed matrices stored in various file formats,
    both from local and remote files. 
    

## Bug fixes

* Pass `query_genome` to `get_LD_vcf()` and `get_LD_matrix`.

# echoLD 0.99.6

## New features

* Perform `liftover` in all areas where necessary. 
* Confirm that UKB is indeed aligned to hg19. 
* Document genome builds of each LD reference panel. 

## Bug fixes

* Fix typos in unit tests: *test-plot_LD*/
* Remove `R.utils` from Imports. 

# echoLD 0.99.5

## New features

* Updated GHA. 

## Bug fixes

* Flipped reporting of SNPs/samples in `compute_LD`. 

# echoLD 0.99.4

## New features

* Switched default conda env to *echoR_mini*. 
* Make dedicated `read_LD_list`.

## Bug fixes

* Change default method for `echotabix::query_vcf` to 
"conda" while "variantannotation" is being fixed. 
* Move extdata example VCFs to `echodata`. 
* Ensure `get_LD` converts returned matrix to sparse for all methods. 
* Pass `conda_env` down to `get_LD_custom`. 

# echoLD 0.99.3

## Bug fixes

* Fix `downloadR`.
* Fix which package *load_ld.py* is imported from (`echodata` --> `echoLD`).
* Remove copy of `dt_to_granges`. 

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
