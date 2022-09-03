#' Convert VCF to PLINK
#' 
#' Convert a Variant Call File (VCF) to
#'  \href{https://www.cog-genomics.org/plink/}{PLINK} format. 
#' @param vcf Specify full name of .vcf or .vcf.gz file.
#' @param output_prefix Specify prefix for output files.
#' @param make_bed  Create a new binary fileset. 
#'  Unlike the automatic text-to-binary converters
#'  (which only heed chromosome filters), this supports all of
#'  PLINK's filtering flags.
#' @param recode Create a new text fileset with all filters applied. 

#' @export
#' @importFrom echoconda find_executables_remote
#' @examples 
#' vcf <- system.file("extdata", "BST1.1KGphase3.vcf.bgz",
#'     package = "echodata")
#' paths <- vcf_to_plink(vcf = vcf)
vcf_to_plink <- function(vcf,
                         output_prefix = NULL,
                         bcftools_path = NULL,
                         make_bed = TRUE,
                         recode = TRUE,
                         verbose = TRUE){
    
    plink <- echoconda::find_executables_remote(tool = "plink")
    if(is.null(output_prefix)){
        output_prefix <- gsub("\\.vcf|\\.gz|.bgz","",
                              file.path(tempdir(),basename(vcf)))
    }
    cmd <- paste(plink,
                 "--vcf",vcf, 
                 if(isTRUE(make_bed))"--make-bed" else NULL,
                 if(isTRUE(recode))"--recode" else NULL,
                 "--out", output_prefix)
    echoconda::cmd_print(cmd, verbose = verbose)
    system(cmd)
    #### Return paths ####
    return_ls <- list(prefix=output_prefix,
                      vcf=vcf)
    if(isTRUE(make_bed)){
        for(x in c("bed","bim","fam")){
            return_ls[[x]] <- paste(output_prefix,x,sep=".")    
        } 
    }
    if(isTRUE(recode)){
        for(x in c("ped","map")){
            return_ls[[x]] <- paste(output_prefix,x,sep=".")    
        } 
    }
    return(return_ls)
}
