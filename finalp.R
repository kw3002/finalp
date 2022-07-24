#Preparation for coding
library(tidyverse)

library(janitor)

library(tseries)

#Calculate annual bank fees for visualization

#read csv

bankfees <- read_csv("tableau bank fee.csv")

bankfees

#calculate annual overdraft fees and annual service fees

bankfees_tableau <- bankfees %>%
  clean_names() %>%
  mutate(annual_service_fee = monthly_fee_for_interest_accounts*12) %>%
  mutate(annual_overdraft_fee = overdraft_fee*9.6)

head(bankfees_tableau, n = 25)

write_csv(bankfees_tableau, "tableau bank fee.csv")

#regression analysis

#read csv
regression <- read_csv("regression.csv")

regression

regression1 <- regression %>%
  clean_names() %>%
  select(x1, bank_fees, x20th_percentile_limit, unbanked_rate, underbanked_rate) %>%
  filter(bank_fees>0, x20th_percentile_limit>0, unbanked_rate>0, underbanked_rate>0)

regression1

#regression on unbanked rate

model1 <- lm(unbanked_rate~ bank_fees + x20th_percentile_limit, regression1)

summary(model1)

install.packages("modelsummary")

library(modelsummary)

msummary(model1)

msummary(model1, 'model1.docx')

#regression on underbanked rate
model2 <- lm(underbanked_rate~ bank_fees + x20th_percentile_limit, regression1)
summary(model2)
msummary(model2, 'model2.docx')

#regression on rate of households that do not have a bank account due to financial reasons
regression2 <- regression %>%
  clean_names() %>%
  select(x1, bank_fees, x20th_percentile_limit, rate_of_respondents_who_do_not_have_a_bank_account_due_to_financial_reasons) %>%
  filter(bank_fees>0, x20th_percentile_limit>0, rate_of_respondents_who_do_not_have_a_bank_account_due_to_financial_reasons>0)

model3 <- lm(rate_of_respondents_who_do_not_have_a_bank_account_due_to_financial_reasons ~ bank_fees + x20th_percentile_limit, regression2)

summary(model3)

msummary(model3, 'model3.docx')

#Check autocorrelation

library(car)

durbinWatsonTest(model1)

durbinWatsonTest(model2)

durbinWatsonTest(model3)	
