#' Translate superopulation acronyms
#'
#' Ensures a common ontology for synonynmous superpopulation names.
#' @family LD
#' @keywords internal
#' @param superpopulation Three-letter superpopulation name.
translate_population <- function(superpopulation) {
    pop_dict <- list(
        "AFA" = "AFR", "CAU" = "EUR", "HIS" = "AMR",
        "AFR" = "AFR", "EUR" = "EUR", "AMR" = "AMR"
    )
    translated.list <- as.character(pop_dict[superpopulation])
    return(translated.list)
}
