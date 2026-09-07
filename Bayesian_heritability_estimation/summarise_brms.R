
library(brms)


model_N50 <- readRDS("models/model_N50_survival.Rds")

model_survival <- readRDS("models/model_survival.Rds")


posterior_N50 <- as_draws_df(model_N50)
posterior_survival <- as_draws_df(model_survival)


get_h2  <- function(posterior) {
  posterior$sd_Id__Intercept^2 / (1 + posterior$sd_Id__Intercept^2)
}

posterior_h2_N50 <- get_h2(posterior_N50)
posterior_h2_survival <- get_h2(posterior_survival)

print("N50 survival")
print(mean(posterior_h2_N50))
print(quantile(posterior_h2_N50, c(0.05, 0.95)))

print("survival")
print(mean(posterior_h2_survival))
print(quantile(posterior_h2_survival, c(0.05, 0.95)))

