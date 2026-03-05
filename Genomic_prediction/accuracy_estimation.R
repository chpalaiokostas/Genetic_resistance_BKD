library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("At least two argument must be supplied (input file).n", call. = FALSE)
}

TEST <- args[1]
DGV <- args[2]

yhat <- read.table(file = "yhat",
                   header = F,
                   sep = "\t",
                   stringsAsFactors = F)

test_ids <- read.table(file = TEST,
                       header = F,
                       sep = " ",
                       stringsAsFactors = F)

dgv <- read.table(file = DGV,
                  header = F,
                  sep = "\t",
                  stringsAsFactors = F)


accuracies <- test_ids %>% inner_join(dgv, by="V1")


accuracies <- accuracies[,c(1,3,5)]
colnames(accuracies) <- c("Id","Days","DGV")
print(cor(accuracies$DGV,accuracies$Days))
