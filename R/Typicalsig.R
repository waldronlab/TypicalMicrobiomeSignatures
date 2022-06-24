#' Calculate the prevalence of species and genera in any subset of cureatedMetagenomicData
#'
#' @param df
#' Any filtered subset of the rows of the sampleMetadata object from curatedMetagenomicData
#' @param rank
#' taxonomic rank to calculate prevalences for. Must be one of "phylum", "class",
#' "order", "family", "genus", or "species"
#' @param prevalencecutoff
#' Minimum prevalence of taxa to include in the output (default: 0.000001)
#' @param thresholdcutoff
#' Minimum relative abundance to consider as present for the prevalence calculation.
#' This is a percentage out of 100. (default: 0)
#'
#' @return
#' A data.frame containing names and prevalences at the taxonomic rank requested
#' @export
#'
#' @examples
#' library(dplyr)
#' healthy <- sampleMetadata %>%
#'    filter(disease == 'healthy') %>%
#'    select(where( ~ !all(is.na(.x)))) %>%
#'    head(100)
#' calcPrevalence(healthy, rank = "phylum")

calcPrevalence <-
    function(df,
             rank,
             prevalencecutoff = 0.000001,
             thresholdcutoff = 0) {
        if (!identical(sum(
            c("phylum", "class", "order", "family", "genus", "species") %in% rank
        ), 1L)) {
            stop(
                "The rank argument must be one of: phylum, class, order, family,
             genus, or species."
            )
        }
        .returnSig <- function(obj,
                               threshold,
                               prevalence) {
            fractionpassing.logical <- rowSums(obj > threshold) / ncol(obj)
            rows.passing <- fractionpassing.logical > prevalence
            return(fractionpassing.logical[rows.passing])
        }
        df_sub1 <-
            df %>% returnSamples("relative_abundance", rownames = "NCBI")
        df_sub2 <-
            df %>% returnSamples("relative_abundance", rownames = "short")
        
        df_sub.byranks <- mia::splitByRanks(df_sub1)
        df_subg1 <-
            .returnSig(assay(df_sub.byranks[[rank]]),
                       prevalence = prevalencecutoff,
                       threshold = thresholdcutoff)
        
        df_sub.byranks <- mia::splitByRanks(df_sub2)
        df_subg2 <-
            .returnSig(assay(df_sub.byranks[[rank]]),
                       prevalence = prevalencecutoff,
                       threshold = thresholdcutoff)
        
        df_subg2 <- tibble(name = names(df_subg2), value = df_subg2)
        
        df_output <- data.frame(df_subg1, df_subg2) %>%
            select(-c("df_subg1")) %>%
            arrange(desc(value))
        df_output$NCBI <- rownames(df_output)
    
        return(df_output)
    }
