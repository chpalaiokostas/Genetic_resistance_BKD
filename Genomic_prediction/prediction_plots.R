library(cvms)
library(tidyverse)
library(ROCR)

test_ids <- read.table(file = "ac_test_tank1.txt",
                       header = F,
                       sep = " ",
                       stringsAsFactors = F)

dgv <- read.table(file = "dgv_tank2_training",
                  header = F,
                  sep = "\t",
                  stringsAsFactors = F)


accuracies <- test_ids %>% inner_join(dgv, by="V1")


accuracies <- accuracies[,c(1,3,5)]
colnames(accuracies) <- c("Id","N50","DGV")
accuracies$N50 <- as.factor(accuracies$N50)
accuracies$Prob <- ifelse(accuracies$DGV > 0,2,1)
print(sum(accuracies$Prob==accuracies$N50)/nrow(accuracies))

ggplot(accuracies, aes(x=N50, y=DGV)) +
  geom_boxplot(fill="cadetblue") +
  scale_x_discrete(labels = c("1" = "Non resistant", "2" = "Resistant")) +
  theme_classic() + 
  theme(plot.title=element_text(size=18,hjust=0.5),
        axis.text.x=element_text(size=16),
        axis.title.x=element_text(size=16),
        axis.text.y=element_text(size=16),
        axis.title.y=element_text(size=16))


### ROC
validation <- prediction(accuracies$DGV,accuracies$N50)
perf <- performance(validation, measure="tpr",x.measure="fpr")
auc <- performance(validation,measure="auc")
auc <- auc@y.values[[1]]
auc

roc_data <- data.frame(fpr=unlist(perf@x.values),tpr=unlist(perf@y.values))

ggplot(roc_data, aes(x=fpr, ymin=0, ymax=tpr)) +
  geom_ribbon(alpha=0.2) +
  geom_line(aes(y=tpr)) +
  ggtitle(paste0("ROC curve  AUC= 0.72")) +
  geom_abline(linetype='dashed') +
  labs(x="False positive rate",y="True positive rate") +
  theme_classic() + 
  theme(axis.text.x=element_text(size=16),
        axis.title.x=element_text(size=16),
        axis.text.y=element_text(size=16),
        axis.title.y=element_text(size=16),
        plot.title = element_text(hjust = 0.5))


### Violin plot

threshold <- 0

# Create the classification types (TN, FP, FN, TP)
df <- accuracies %>%
  mutate(Survived = factor(N50, levels = c(1, 2), 
                           labels = c("Non-resistant", "Resistant")),
         Prediction = ifelse(DGV > threshold, 1, 0),
         Classification = case_when(
          N50 == 1 & DGV < threshold  ~ "TN",
          N50 == 1 & DGV >= threshold ~ "FP",
          N50 == 2 & DGV < threshold  ~ "FN",
          N50 == 2 & DGV >= threshold ~ "TP"
  ))


ggplot(df, aes(x = Survived, y = DGV)) +
  geom_violin(fill = "grey95", color = NA, alpha = 0.5) +
  
  geom_jitter(aes(color = Classification), width = 0.25, size = 1, alpha = 0.6) +
  
  geom_hline(yintercept = threshold, color = "red", linetype = "solid") +
  
  scale_color_manual(values = c(
    "TN" = "#00BFC4", # Teal/Blue
    "FP" = "#A3A500", # Olive Green
    "FN" = "#F8766D", # Coral/Red
    "TP" = "#C77CFF"  # Purple
  )) +
  
  theme_minimal() +
  labs(x = "Survival status", y = "DGV") 
  theme(legend.position = "none") # Hide legend to match image

  
### Confusion matrix
  
cm <- evaluate(df, target_col = "Survived", 
               prediction_cols = "Prediction",
               type = "binomial")

plot_confusion_matrix(cm[["Confusion Matrix"]][[1]],
                      add_row_percentages = FALSE,
                      add_col_percentages = FALSE,
                      add_counts = FALSE)

  