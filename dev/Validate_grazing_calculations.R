
################################################################################
#
# Validate_grazing_calculations.R
#
#  Gareth Rowell, 5/15/2024
#
#  Validating grazing calculations (here) against
#     calculations in origina Access grazing 
#     database: GrazingStocking3.52.accdb
#
#
#  task list:
#
#  1) review stocking rate calcutions in original database
#  2) using table values in original database, replicate those calculations
#    in the R script, step-by-step
#  3) Once calculations are working in R script, return to the complete
#    dataset including records from Multi-grazing
#  4) must accomodate combining gas house and west branch as big pasture for
#    1995 - 2006 data
#  5) Sherry has asked to drop 2006 data. Verify this.
#
#
#
################################################################################


library(tidyverse)

#setwd("./src")

df <-  read_csv("qryexp_Grazing.csv")

problems(df)

glimpse(df)

# view(df)

# calculations derived from Access database

# Q_AUE: Round([i]/750,2)
# Q_MONTHS_ON: Round([NUMBER_DAYS_ON]/30,2)
# Q_AUM: Round([Q_AUE]*[Q_MONTHS_ON],2)

#qrycal_AUE

df <- df |>
  mutate(
    Q_AUE = TOTAL_LBS_IN / 750,
    Q_MONTHS_ON = NUMBER_DAYS_ON / 30,
    Q_AUM = Q_AUE * Q_MONTHS_ON
  ) |> 
  select( Grazing_ID, TOTAL_LBS_IN, GRAZABLE_ACRES,  Q_AUE, Q_MONTHS_ON, Q_AUM) |>
  arrange(Grazing_ID)
#qrycal_StockingRate

df |> 
  mutate(
    Q_AUM_STOCKING_RATE = Q_AUM / GRAZABLE_ACRES,
    Q_ACRES_STOCKING_RATE = GRAZABLE_ACRES / Q_AUM
  ) |>
  view()






