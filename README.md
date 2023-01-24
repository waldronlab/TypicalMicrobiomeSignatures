# TypicalMicrobiomeSignatures

## Requirements

Install the following packages:

* Bioconductor package [curatedMetagenomicData](https://bioconductor.org/packages/release/curatedMetagenomicData)
* tidyverse package [dplyr](https://dplyr.tidyverse.org)
* TypicalMicrobiomeSignatures

Using BiocManager to install:

```
BiocManager::install(c("curatedMetagenomicData", "dplyr",
                       "waldronlab/TypicalMicrobiomeSignatures"))
```

## Signature and Prevalance Files 

Run `Rscript inst/R/write_sigs-to_file.R` to generate 4 typical healthy
signature and prevalence csv files:

1. matrix_genus_adult.csv
2. matrix_species_adult.csv
3. matrix_genus_child.csv
4. matrix_species_child.csv

The most recent release versions of the signature and prevalence files are available on
Zenodo at
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7544550.svg)](https://doi.org/10.5281/zenodo.7544550).
Prior release versions are available at
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6656514.svg)](https://doi.org/10.5281/zenodo.6656514).
The devel version of the files are available at
[TypicalMicrobiomeSignaturesExports](https://github.com/waldronlab/TypicalMicrobiomeSignaturesExports).

## Example Analysis

Run [BugSigDBStats](http://waldronlab.io/BugSigDBStats/) for an example
analysis applying typical healthy signatures to an epidemiological analysis.
