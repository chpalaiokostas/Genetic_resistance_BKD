ac_pheno <- read.table(file="ac_bkd_surviving_days.txt",
                       header=F,
                       sep=" ",
                       stringsAsFactors = F)


set.seed(1830) # 1830, 1821, 2021, 2023,2026
fold <- 3
N <- nrow(ac_pheno)
rem <- 1:N
group_size <- floor(N/fold)
ncv <- cumsum(rep(group_size,fold))
id <- list()

for(i in 1:length(ncv)) {
  tst <- sample(rem,size=group_size,replace=F)
  rem <- setdiff(rem,tst)
  id[[i]] <- tst
}

for(i in 1:3) {
  write.table(ac_pheno[-id[[i]],],
              file=paste("ac_pheno_val",i,".txt",sep=""),
              row.names=F,
              quote=F,
              sep=" ",
              col.names = F)
  write.table(ac_pheno[id[[i]],],
              file=paste("ac_pheno_tst",i,".txt",sep=""),
              row.names=F,
              quote=F,
              sep=" ",
              col.names = F)
}

