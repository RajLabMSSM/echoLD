#' Get LD from pre-computed matrix
#'
#' Get LD from a pre-computed matrix of pairwise 
#' \ifelse{html}{\out{r}}{\eqn{r}} / 
#' \ifelse{html}{\out{r<sup>2</sup>}}{\eqn{r^2}}values.
#' @param stats The linkage disequilibrium measure to be calculated. 
#' Can be \code{"R"} (default) or \code{"R.squared"}. 
#' @param fillNA When pairwise LD between two SNPs is \code{NA},
#' replace with 0.
#' @inheritParams get_LD
#' @inheritParams echotabix::query
#'
#' @family LD
#' @importFrom echotabix liftover
#' @export 
#' @examples 
#' query_dat <-  echodata::BST1[seq(1, 50), ] 
#' locus_dir <- file.path(tempdir(),  echodata::locus_dir)
#' LD_reference <- tempfile(fileext = ".csv")
#' utils::write.csv(echodata::BST1_LD_matrix,
#'                  file = LD_reference,
#'                  row.names = TRUE)
#' LD_list <- get_LD_matrix(
#'     locus_dir = locus_dir,
#'     query_dat = query_dat,
#'     LD_reference = LD_reference)
get_LD_matrix <- function(locus_dir = tempdir(),
                          query_dat,
                          LD_reference,
                          query_genome = "hg19",
                          target_genome = "hg19",
                          fillNA = 0,
                          stats = "R",
                          as_sparse = TRUE,
                          subset_common = TRUE,
                          verbose = TRUE) {
    
    messager("Using custom VCF as LD reference panel.", v = verbose)  
    #### Query ####
    query_dat_lifted <- echotabix::liftover(dat = query_dat, 
                                            query_genome = query_genome, 
                                            target_genome = target_genome,
                                            as_granges = FALSE,
                                            verbose = verbose)
    LD_list <- read_LD_list(LD_path = LD_reference, 
                            query_dat = query_dat_lifted, 
                            as_sparse = as_sparse,
                            verbose = verbose)
    #### Convert to r if needed ####
    r2r_out <- r2_to_r(LD_matrix = LD_list$LD,
                       LD_path = LD_reference,
                       stats = stats,
                       verbose = verbose)
    #### Get LD #### 
    #### Save LD matrix ####
    LD_list <- save_LD_matrix(
        LD_matrix = r2r_out$LD_matrix,
        dat = query_dat,
        locus_dir = locus_dir,
        fillNA = fillNA,
        LD_reference = paste("custom",r2r_out$LD_metric,sep="_"),
        as_sparse = as_sparse,
        verbose = verbose,
        subset_common = subset_common
    ) 
    return(LD_list)
}
