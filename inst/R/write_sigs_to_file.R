library(curatedMetagenomicData)
library(dplyr)

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
for (bodysite in bodysites) {
    adultgenus[[bodysite]] <-
        calcPrevalence(filter(adult, body_site == bodysite), rank = "genus") %>%
        dplyr::rename(paste0(bodysite, "_genus_prevalence") = genus.value)
    adultspecies[[bodysite]] <-
        calcPrevalence(filter(adult, body_site == bodysite), rank = "species") %>%
        dplyr::rename(paste0(bodysite, "_species_prevalence") = species.value)
}

## make two matricies: one for all species, one for all genera, stratified by body site

###genus

matrix_genus <-
    plyr::join_all(adultgenus,
                   by = 'NCBI',
                   type = 'full')
matrix_genus[is.na(matrix_genus)] <- 0
write.csv(matrix_genus, "~matrix_genus_adult.csv", row.names = TRUE)

###species

matrix_species <-
    plyr::join_all(adultspecies,
                   by = 'NCBI',
                   type = 'full')
matrix_genus[is.na(matrix_species)] <- 0
write.csv(matrix_genus, "~matrix_species_adult.csv", row.names = TRUE)

# child

childbodysites <- c("oralcavity", "nasalcavity", "stool")

childgenus <- list()
childspecies <- list()
for (bodysite in bodysites) {
    childgenus[[bodysite]] <-
        calcPrevalence(filter(child, body_site == bodysite), rank = "genus") %>%
        dplyr::rename(paste0(bodysite, "_genus_prevalence") = genus.value)
    childspecies[[bodysite]] <-
        calcPrevalence(filter(child, body_site == bodysite), rank = "species") %>%
        dplyr::rename(paste0(bodysite, "_species_prevalence") = species.value)
}

## make two matricies: one for all species, one for all genera, stratified by body site

###genus

matrix_genus <-
    plyr::join_all(childgenus,
                   by = 'NCBI',
                   type = 'full')
matrix_genus[is.na(matrix_genus)] <- 0
write.csv(matrix_genus, "~matrix_genus_child.csv", row.names = TRUE)

###species

matrix_species <-
    plyr::join_all(childspecies,
                   by = 'NCBI',
                   type = 'full')
matrix_genus[is.na(matrix_species)] <- 0
write.csv(matrix_genus, "~matrix_species_child.csv", row.names = TRUE)
