
library(assertthat)
library(readr)
library(brms)
library(tidyr)


grm <- read_tsv("gcta.grm", col_names = FALSE)
colnames(grm) <- c("ind1", "ind2", "n_snps", "rel")

ids <- read_tsv("gcta.grm.id", col_names = FALSE)
colnames(ids) <- c("FID", "IID")


Gmat <- matrix(0, ncol = nrow(ids), nrow = nrow(ids))

for (row_ix in 1:nrow(grm)) {
  Gmat[grm$ind1[row_ix], grm$ind2[row_ix]] <- grm$rel[row_ix]
  Gmat[grm$ind2[row_ix], grm$ind1[row_ix]] <- grm$rel[row_ix]
}


pheno <- read_tsv("data/LD_array_BKD_common/bkd_survival.txt")

pheno$tank <- NA_real_
pheno$tank[grepl("^I10", pheno$Id)] <- 0
pheno$tank[grepl("^I11", pheno$Id)] <- 1

assert_that(identical(pheno$Id, ids$IID))

missing <- is.na(pheno$Survival)

pheno_pruned <- pheno[!missing,]

Gmat_pruned <- Gmat[!missing, !missing]

colnames(Gmat_pruned) <- pheno_pruned$Id
rownames(Gmat_pruned) <- pheno_pruned$Id

beta <- 0.1

Gmat_blended <- Gmat_pruned * (1 - beta) + beta * diag(nrow(Gmat_pruned))

model <- brm(
  Survival ~ 1 + tank +
    (1 | gr(Id, cov = G)),
  data = pheno_pruned,
  data2 = list(G = Gmat_blended),
  family = bernoulli(link = "probit"),
  cores = 4, iter = 10000,
  control = list(adapt_delta = 0.99)
)

  
# model1 <- brm(
#   Survival ~ 1 + (1 | Id),
#   data = pheno_pruned,
#   cov_ranef = list(Id = Gmat_blended),
#   family = bernoulli(),
#   cores = 4, iter = 1000,
#   control = list(adapt_delta = 0.9)
# )


dir.create("models")

saveRDS(model, file = "models/model_survival.Rds")


