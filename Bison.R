library(tidyverse)
library(janitor)

setwd("C:\\Users\\smead\\OneDrive - DOI\\Documents\\SMM Databases") ## replace within "" the file path where your data is stored

Bison <- read.csv("Nov2024 TPNP Bison Herd GAllagher Export.csv") 

Bison_counts <- Bison %>%
  mutate(AnimalType = ifelse(Birth.Year == max(Birth.Year), "BCalf", ifelse(Birth.Year == max(Birth.Year)-1, "BYearling", ifelse(Sex == "Male", "BBull", "BCow")))) %>%
  group_by(AnimalType)%>%
  summarise(count = n(),
            weight = sum(Live.Weight..lb.)) %>%
  adorn_totals()

write.csv(Bison_counts, 'Bison_counts.csv', row.names = F) ## bison_counts.csv contains the calculated dataframe

