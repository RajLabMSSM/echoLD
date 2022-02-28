# LD_with_leadSNP <- function(LD_matrix,
#                             LD_SNP){
#   messager("LD Matrix dimensions:", paste(dim(LD_matrix), collapse=" x "))
#   messager("Extracting LD subset for lead SNP:",LD_SNP)
#   LD_sub <- subset(LD_matrix, select=LD_SNP) %>%
#     data.table::as.data.table(keep.rownames  =  TRUE) %>%
#     `colnames<-`(c("SNP","r")) %>%
#     dplyr::mutate(r2 = r^2)
#   return(LD_sub)
# }
