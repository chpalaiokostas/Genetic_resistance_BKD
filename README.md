# Genetic resistance against BKD

The repository's code has been used to conduct the genetic analysis of the BKD study

In total approximately 2000 animals from year class 2025 were used.

The following briefly describes the conducted data analysis:

## Exploratory analysis

* Plot depicting surviving days
* Plot RT-PCR Ct vs surviving days.
* PCA analysis.

The R code is available under `Exploratory_analysis/BKD_descriptive_analysis.R`.

## Pedigree reconstruction

The software seekparentf90 from the blupf90 suite was used. 

* Plot depicting assignment to full-sib families.

The R code for the plot is available under `Pedigree_reconstruction/Full_sibs_GRM.R`.

## Heritability estimation

The blupf90 suite was used.

* Log file of h2 for surviving days
* Log file of h2 for N50 survival
* Log file of h2 for overall survival

## GWAS 

* Plot depicting wssGWAS for surviving days and N50 survival

## Genomic prediction

A 3-fold cross validation was performed for surviving days and N50 survival. The above was replicated five times.

For the N50 survival the fish of each tank were subsequently used as training and test set respectively .

The created plot used R code found under  `GS/prediction_plots.R`.
 
