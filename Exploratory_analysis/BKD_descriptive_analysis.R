library(tidyverse)

pheno <- read.table(file = "phenos_bkd_all.txt",
                    header = T,
                    stringsAsFactors = F,
                    sep = "\t")

pheno |> 
  filter(!is.na(Surviving_days)) |>
  ggplot(aes(Surviving_days)) +
    geom_histogram(bins = 20) +
    facet_wrap(~ Tank) +
    theme(plot.title=element_text(size=18,hjust=0.5),
        axis.text.x=element_text(size=16),
        axis.title.x=element_text(size=16),
        axis.text.y=element_text(size=16),
        axis.title.y=element_text(size=16)
    )
  
        
qPCR_pheno <- read.table(file = "bkd_qPCR.txt",
                         header = T,
                         stringsAsFactors = F,
                         sep = "\t")

qPCR_pheno$Tank <- as.factor(qPCR_pheno$Tank)

cor(qPCR_pheno$Ct,qPCR_pheno$Surviving_days, use="complete.obs")

qPCR_pheno |> 
  filter(!is.na(Surviving_days)) |>
  ggplot(aes(x=Surviving_days,y=Ct)) +
  geom_point(aes(color = Tank),alpha=0.5,size=3,position="jitter") +
  geom_smooth(method = "lm")
  theme(plot.title=element_text(size=18,hjust=0.5),
        axis.text.x=element_text(size=16),
        axis.title.x=element_text(size=16),
        axis.text.y=element_text(size=16),
        axis.title.y=element_text(size=16)
  )


