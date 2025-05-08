


################################################################################
#
#  GrazingCalculationsQC.R
#
#  Gareth Rowell, 5/20/2024
#
#  QCing grazing calculations generated from 
#    TAPR_grazing_calculations.R
#
################################################################################


library(tidyverse)

grazing_calc <- read_csv("./Grazing_calculations_final.csv")

problems(grazing_calc)


view(grazing_calc)

glimpse(grazing_calc)


# Variable: pasture  -----------------------------------------------------------

grazing_calc |> distinct(pasture)

ggplot(grazing_calc, aes(x = pasture)) + 
  geom_bar()


# Variable: acres  -------------------------------------------------------------

ggplot(grazing_calc, aes(x = acres)) +
  geom_histogram(binwidth = 500)


# Variable: grazing_year -------------------------------------------------------


ggplot(grazing_calc, aes(x = grazing_year)) +
  geom_histogram(binwidth = 1)



# Variable: actual_days_on -----------------------------------------------------

ggplot(grazing_calc, aes(x = actual_days_on)) +
  geom_histogram(binwidth = 5)


# Variable: head_on ------------------------------------------------------------


ggplot(grazing_calc, aes(x = head_on)) +
  geom_histogram(binwidth = 50)


# Variable: head_off -----------------------------------------------------------


ggplot(grazing_calc, aes(x = head_off)) +
  geom_histogram(binwidth = 50)



# Variable: lbs_on  ------------------------------------------------------------


ggplot(grazing_calc, aes(x = lbs_on)) +
  geom_histogram(binwidth = 50000)


# Variable: lbs_off  -----------------------------------------------------------


ggplot(grazing_calc, aes(x = lbs_off)) +
  geom_histogram(binwidth = 50000)



# Variable: ave_animal_weight  -------------------------------------------------


ggplot(grazing_calc, aes(x = ave_animal_weight)) +
  geom_histogram(binwidth = 50)



# Variable: aue  ---------------------------------------------------------------
 

ggplot(grazing_calc, aes(x = aue)) +
  geom_histogram(binwidth = 50)


# Variable: months  ------------------------------------------------------------


ggplot(grazing_calc, aes(x = months)) +
  geom_histogram(binwidth = 1)

# Variable: aum  ---------------------------------------------------------------


ggplot(grazing_calc, aes(x = aum)) +
  geom_histogram(binwidth = 500)


# Variable: stocking rate  -----------------------------------------------------


ggplot(grazing_calc, aes(x = stocking_rate)) +
  geom_histogram(binwidth = .1)

# Variable: acres_sr  ----------------------------------------------------------


ggplot(grazing_calc, aes(x = acres_sr)) +
  geom_histogram(binwidth = .5)



