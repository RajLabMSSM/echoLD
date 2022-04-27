#' Subset VCF samples
#'
#' Subsrt VCF samples by superpopulation.
#' @inheritParams get_LD
#' @inheritParams echotabix::query_vcf
#' @inheritParams echodata::mungesumstats_to_echolocatoR
#' @export 
select_vcf_samples <- function(superpopulation = NULL,
                               samples = NULL,
                               LD_reference = "1KGphase1",
                               verbose = TRUE) {
    # Avoid confusing checks
    superpop <- NULL
    
    LD_reference <- check_LD_reference_1kg(LD_reference=LD_reference) 
    if (is.null(superpopulation) && length(samples)==0) {
        return(character())
    }
    if(!is.null(superpopulation)){ 
        superpopulation <- check_population_1kg(superpopulation=superpopulation,
                                                LD_reference=LD_reference)
    }
    #### Select popDat ####
    if (LD_reference == "1kgphase1") {
        popDat <- echoLD::popDat_1KGphase1
    } else if (LD_reference == "1kgphase3") {
        popDat <- echoLD::popDat_1KGphase3
    } else {
        stp <- paste0("LD_reference must be one of:\n",
                     paste(" -",c("1kgphase1","1kgphase3"), 
                           collapse = "\n"))
        stop(stp)
    }
    #### Subset samples by superpopulation ####
    if(is.null(superpopulation)){
        samples_select <- popDat$sample
    } else {
        samples_select <- unique(
            subset(popDat, superpop == superpopulation)$sample
        )
    }
    #### Subset samples by sample names ####
    samples_select <- grep(paste(samples,collapse = "|"), samples_select, 
                           value = TRUE, ignore.case = TRUE)
    #### Check how many samples are left ####
    if(length(samples_select)==0){
        stp2 <- paste0("0 matching samples could be identified in ",
                       LD_reference,".")
        stop(stp2)
    } else {
        messager("Selecting", length(samples_select),
                 superpopulation, "individuals from", 
                 paste0(LD_reference, "."),
                 v = verbose
        ) 
    } 
    return(samples_select)
}
