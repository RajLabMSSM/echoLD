check_LD_reference_1kg <- function(LD_reference){
    
    LD_reference <- tolower(LD_reference[1])
    if (!LD_reference %in% c("1kgphase1","1kgphase3")) {
        stp <- paste0("LD_reference must be one of:\n",
                      paste(" -",c("1kgphase1","1kgphase3"), collapse = "\n"))
        stop(stp)
    } else {
        return(LD_reference)
    } 
}