# install data package
remotes::install_github("higgi13425/medicaldata")
# load packages
library(tidyverse)

# laod data
data("opt", package = "medicaldata")

# prepping data for workshop
df_opt <- 
  as_tibble(opt) %>%
  janitor::clean_names() %>%
  select(pid, clinic, group, age, black, white, nat_am, asian, hisp,
         hypertension, diabetes, bmi, use_tob, use_alc, prev_preg,
         birthweight, ga_at_outcome, preg_ended_37_wk) %>%
  # converting Yes/No to include the missing values
  mutate_at(vars(black, white, nat_am, asian, hisp, use_tob, use_alc,
                 prev_preg, diabetes, preg_ended_37_wk), 
            ~as.character(.) %>% 
              str_trim() %>%
              ifelse(. == "", NA_character_, .) %>%
              factor(levels = c("No", "Yes"))) %>%
  mutate_at(vars(hypertension), 
            ~as.character(.) %>% 
              str_trim() %>%
              ifelse(. == "", NA_character_, .) %>%
              factor(labels = c("No", "Yes"), levels = c("N", "Y"))) %>%
  mutate(group = factor(group, 
                        labels = c("Periodontal Treatment", "Control Group"), 
                        levels = c("T", "C")),
         ga_at_outcome = ifelse(is.na(preg_ended_37_wk), 
                                NA, 
                                ga_at_outcome / 7))
  
# save data
saveRDS(df_opt, file = here::here("data", "df_opt.rds")) 
saveRDS(df_opt, file = here::here("student-materials", "data", "df_opt.rds")) 
