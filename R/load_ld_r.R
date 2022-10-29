load_ld_r <- function(URL,
                      verbose=TRUE){
    
    reticulate::source_python(
        system.file("tools", "load_ld.py",package = "echoLD"
        ))
    messager("load_ld() python function input:",URL,v = verbose)
    messager("Reading LD matrix into memory.",
             "This could take some time...",v = verbose)  
    ld.out <- reticulate::py$load_ld(URL, server=FALSE) 
    #### Check if it worked ####
    if(length(ld.out)==0) {
        stp <- "load_ld() failed."
        stop(stp)
    }
    return(ld.out)
}