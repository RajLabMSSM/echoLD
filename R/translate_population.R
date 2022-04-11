#' Translate superpopulation acronyms
#'
#' Ensures a common ontology for synonymous superpopulation names.
#' @family LD
#' @keywords internal
#' @inheritParams get_LD
check_population_1kg <- function(superpopulation,
                                 LD_reference) {
    
    LD_reference <- check_LD_reference_1kg(LD_reference=LD_reference)
    superpopulation <- toupper(superpopulation)[1]
    
    if(LD_reference=="1kgphase1"){
        pops <- sort(unique(echoLD::popDat_1KGphase1$superpop))
        # "AFR" "AMR" "ASN" "EUR"
        pop_dict <- list( 
            "AFA" = "AFR",
            "HIS" = "AMR",
            "EAS" = "ASN",
            "CAU" = "EUR"
        )
        if(superpopulation %in% names(pop_dict)){
            superpopulation <- pop_dict[[superpopulation]]
        }
        if(!superpopulation %in% pops){
            stp <- paste("Cannot find",superpopulation,
                         "superpopulation in",LD_reference)
            stop(stp)
        }
    } else if(LD_reference=="1kgphase3"){
        pops <- sort(unique(echoLD::popDat_1KGphase3$superpop))
        # "AFR" "AMR" "EAS" "EUR" "SAS"
        pop_dict <- list( 
            "AFA" = "AFR",
            "HIS" = "AMR", 
            ### Omit due to ambiguity
            # "ASN" = "EAS" OR "SAS" 
            "CAU" = "EUR" 
        )
        if(superpopulation %in% names(pop_dict)){
            superpopulation <- pop_dict[[superpopulation]]
        }
        if(!superpopulation %in% pops){
            stp <- paste("Cannot find",superpopulation,
                         "superpopulation in",LD_reference,".")
            stop(stp)
        }
    }   
    return(superpopulation)
}
