#' Subset VCF samples
#'
#' @inheritParams echotabix::query_vcf
#' @keywords internal
select_vcf_samples <- function(superpopulation = NULL,
                               samples = NULL,
                               LD_reference = "1KGphase1",
                               verbose = TRUE) {
    # Avoid confusing checks
    superpop <- NULL

    if (is.null(superpopulation)) {
        return(character())
    }
    if (all((!is.null(samples)), (length(samples) > 1))) {
        return(samples)
    }
    LD_reference <- tolower(LD_reference[1])
    if (LD_reference == "1kgphase1") {
        popDat <- echoLD::popDat_1KGphase1
    }
    if (LD_reference == "1kgphase3") {
        popDat <- echoLD::popDat_1KGphase3
    }
    superpopulation <- translate_population(superpopulation = superpopulation)
    selectedInds <- unique(subset(popDat, superpop == superpopulation)$sample)
    messager("echoLD:: Selecting", length(selectedInds),
        superpopulation, "individuals from", paste0(LD_reference, "."),
        v = verbose
    )
    return(selectedInds)
}
