library(curatedMetagenomicData)
library(dplyr)
library(TypicalMicrobiomeSignatures)

healthy <- sampleMetadata %>%
    filter(disease == 'healthy') %>%
    select(where( ~ !all(is.na(.x))))

adult <- healthy %>%
    filter(age_category %in% (c("adult", "senior")))
child <- healthy %>%
    filter(age_category %in% (c("child", "newborn", "schoolage")))

# adult

adultbodysites <- c("skin", "vagina", "oralcavity", "nasalcavity", "stool")

adultgenus <- list()
adultspecies <- list()
for (bodysite in adultbodysites) {
    adultgenus[[bodysite]] <-
        calcPrevalence(filter(adult, body_site == bodysite), rank = "genus")
    names(adultgenus[[bodysite]])[names(adultgenus[[bodysite]]) == "value"] <-
        paste0(bodysite, "_genus_prevalence")
    adultspecies[[bodysite]] <-
        calcPrevalence(filter(adult, body_site == bodysite), rank = "species")
    names(adultspecies[[bodysite]])[names(adultspecies[[bodysite]]) == "value"] <-
        paste0(bodysite, "_species_prevalence")
}

## make two matrices: one for all species, one for all genera, stratified by body site

###genus

matrix_genus <-
    plyr::join_all(adultgenus,
                   by = 'NCBI',
                   type = 'full')
matrix_genus[is.na(matrix_genus)] <- 0
ordered_matrix_genus <- matrix_genus %>%
  select(NCBI, everything())
write.csv(ordered_matrix_genus, "matrix_genus_adult.csv", row.names = FALSE)

###species

matrix_species <-
    plyr::join_all(adultspecies,
                   by = 'NCBI',
                   type = 'full')
matrix_species[is.na(matrix_species)] <- 0
ordered_matrix_species <- matrix_species %>%
    select(NCBI, everything())
write.csv(ordered_matrix_species, "matrix_species_adult.csv", row.names = FALSE)

# child

childbodysites <- c("oralcavity", "nasalcavity", "stool")

childgenus <- list()
childspecies <- list()
for (bodysite in childbodysites) {
    childgenus[[bodysite]] <-
        calcPrevalence(filter(child, body_site == bodysite), rank = "genus")
    names(childgenus[[bodysite]])[names(childgenus[[bodysite]]) == "value"] <-
        paste0(bodysite, "_genus_prevalence")
    childspecies[[bodysite]] <-
        calcPrevalence(filter(child, body_site == bodysite), rank = "species")
    names(childspecies[[bodysite]])[names(childspecies[[bodysite]]) == "value"] <-
        paste0(bodysite, "_species_prevalence")
}

## make two matrices: one for all species, one for all genera, stratified by body site

###genus

matrix_genus <-
    plyr::join_all(childgenus,
                   by = 'NCBI',
                   type = 'full')
matrix_genus[is.na(matrix_genus)] <- 0
ordered_matrix_genus <- matrix_genus %>%
  select(NCBI, everything())
write.csv(ordered_matrix_genus, "matrix_genus_child.csv", row.names = FALSE)

###species

matrix_species <-
    plyr::join_all(childspecies,
                   by = 'NCBI',
                   type = 'full')
matrix_species[is.na(matrix_species)] <- 0
ordered_matrix_species <- matrix_species %>%
  select(NCBI, everything())
write.csv(ordered_matrix_species, "matrix_species_child.csv", row.names = FALSE)

