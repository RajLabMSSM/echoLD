#' Convert \ifelse{html}{\out{r<sup>2</sup>}}{\eqn{r^2}}
#'  to \ifelse{html}{\out{r}}{\eqn{r}}, and vice versa
#' 
#' Infers which LD correlation metric the \code{LD_matrix} currently contains, 
#' and converts it to the requested LD correlation metric.
#' \bold{NOTE: } Since +/- valence cannot be recovered from an 
#' \ifelse{html}{\out{r<sup>2</sup>}}{\eqn{r^2}} matrix, 
#' \ifelse{html}{\out{r<sup>2</sup>}}{\eqn{r^2}}
#'  can only be converted to \emph{absolute} 
#'  \ifelse{html}{\out{r}}{\eqn{r}}.
#' @param LD_matrix LD matrix. 
#' @param LD_path [Optional] Path where LD matrix is stored. This is used to 
#' determine whether the matrix has already been converted to absolute 
#'  \ifelse{html}{\out{r}}{\eqn{r}} based on the presence of the 
#'  "rAbsolute" substring (to avoid taking the square root twice).
#' @inheritParams get_LD_matrix 
#' @returns Named list containing the LD matrix and which LD metric 
#' is has been formatted to.
#' 
#' @export
#' @examples 
#' LD_matrix <- echodata::BST1_LD_matrix
#' r2r_out <- r2_to_r(LD_matrix = LD_matrix)
r2_to_r <- function(LD_matrix,
                    LD_path="",
                    stats="R",
                    verbose=TRUE){
    
    messager("Checking LD metric (r/r2).",v=verbose)
    stats <- tolower(stats)[[1]]
    if(sum(LD_matrix<0)==0 && 
       stats=="r" &&
       (!grepl("rAbsolute",LD_path))){
        messager(
            "LD_matrix inferred to be r2 due to lack of negative values.",
            "Converting r2 to absolute r.",v=verbose)
        LD_matrix <- sqrt(LD_matrix)
        LD_metric <- "rAbsolute"
    } else if(stats=="r.squared"){
        if(grepl("rAbsolute",LD_path)){
            messager(
                "LD_matrix inferred to be r due to presence of",
                "'rAbsolute' substring in LD_path name.",
                "Converting r to r^2.",v=verbose)
        } else {
            messager(
                "LD_matrix inferred to be r due to presence of",
                "negative values.",
                "Converting r to r^2.",v=verbose)
        }
        
        LD_matrix <- LD_matrix^2 
        LD_metric <- "rSquared"
    } else {
        LD_metric <- "r"
    }
    return(list(LD_matrix=LD_matrix,
                LD_metric=LD_metric))
}
