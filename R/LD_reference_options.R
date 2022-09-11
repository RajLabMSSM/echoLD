LD_reference_options <- function(LD_reference=NULL,
                                 as_subgroups=FALSE,
                                 verbose=TRUE){
    
    table_opts <- c(".tsv",".csv",".txt")
    matrix_opts <- c(".mtx")
    opts <- list("ukb"=c("ukb"),
                 "1kg"=c("1kgphase1", "1kgphase3"),
                 "vcf"=c(".vcf", ".vcf.gz", ".vcf.bgz"),
                 "matrix"=c(".rds",".rda",".rdata",
                            c(table_opts,matrix_opts),
                            paste0(c(table_opts,matrix_opts),".gz")
                            )
                 ) 
    if(isTRUE(as_subgroups)){
        opts$matrix <- NULL
        opts <- c(opts, list(
            "r"=c(".rds",".rda"),
            "table"=c(table_opts,paste0(table_opts,".gz")),
            "Matrix Market"=c(matrix_opts,paste0(matrix_opts,".gz"))
            ) )
    }
    if(is.null(LD_reference)){
        return(opts)
    } else {
        LD_reference <- tolower(LD_reference)[[1]]
        selected_opt <- names(opts)[unlist(
            lapply(opts, function(o){grepl(paste0(o,"$",collapse = "|"),
                                                  LD_reference,
                                           ignore.case = TRUE)}))
        ][[1]]
        if(length(selected_opt)>0){
            messager("LD_reference identified as:",paste0(selected_opt,"."),
                     v=verbose)
        } else {
            msg <- paste0(
                "LD_reference input not recognized.", 
                " Must both one of:\n",
                paste0(" - ",
                       c(
                           paste("Remote LD reference panel:",
                                 paste0("'",c(opts$ukb,opts$`1kg`),"'",
                                        collapse = " / ")),
                           paste("Path to VCF file:",
                                 paste0("'*",opts$vcf,"'",
                                        collapse = " / ")),
                           paste("Path to LD matrix file:",
                                 paste0("'*",opts$matrix,"'",
                                        collapse = " / "))
                       ),
                       collapse = "\n"
                )
            )
            stop(msg)
        } 
        return(selected_opt)
    }
}
