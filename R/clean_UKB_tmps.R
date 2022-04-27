clean_UKB_tmps <- function(URL,
                           verbose=TRUE){
    gz_file <- paste0(URL, ".gz")
    npz_file <- paste0(URL, ".npz")
    tryCatch({
        if (length(gz_file)>0 && file.exists(gz_file)) {
            messager("+ Removing .gz temp files.",v=verbose)
            file.remove(gz_file)
        }
    }, error = function(e){message(e)})
    
    tryCatch({
        if (length(npz_file)>0 && file.exists(npz_file)) {
            messager("+ Removing .npz temp files.",v=verbose)
            file.remove(npz_file)
        }
    }, error = function(e){message(e)})
}