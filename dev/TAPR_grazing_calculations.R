
################################################################################
#
#  TAPR_grazing_calculations.R
#
#  Gareth Rowell, 5/20/2024
#
#  Grazing stocking calculations using data from GrazingStocking3.52.accdb and
#    MultiGrazingStocking1.29.accdb
#
#
################################################################################



library(tidyverse)
library(writexl)

#setwd("./src")

#################---------------------------------------------------------------
#
# Step 1 - load .csv file from GrazingStocking3.52.accdb
#   and filter out NAs in date out and 0's in total lbs out.
#
#################

orig_data <-  read_csv("qryexp_Grazing.csv")

glimpse(orig_data)

###view(orig_data)

# filter out records with NA in DATE_OUT and total lbs out that are zero

orig_data <- orig_data |>
              filter((TOTAL_LBS_OUT > 0)&(!is.na(NUMBER_DAYS_ON))&(TOTAL_LBS_IN > 0))

glimpse(orig_data)

#view(orig_data)

#################
#
# Step 2 - combine data from gas house and west branch
#   Note that this combined data used NUMBER_DAYS_ON
#   taken directly from the csv file. It is NOT the 
#   result of differences between dates on and off
#   So stocking rates have to be calculated separately
#   in Step 6 then combined with the rest of the data. 
#   
#################

# combine data from gas house and west branch

ga_wb_data <- orig_data |>
  filter((Pasture_ID == "Ga")|(Pasture_ID == "WB")) |>
  
  mutate(
    grazing_year = Year
  )


# ##view(ga_wb_data) #- no duplicates

# This reframe generates duplicate records for big pasture

big_pasture <- ga_wb_data |>
  group_by(grazing_year) |>
  mutate(
    Pasture_ID = "Bi",
    PASTURE = "Big",
    GRAZABLE_ACRES = sum(GRAZABLE_ACRES),
    TOTAL_LBS_IN = sum(TOTAL_LBS_IN),
    TOTAL_LBS_OUT = sum(TOTAL_LBS_OUT),
    TOTAL_GAIN = sum(TOTAL_GAIN),
    NUMBER_HEAD_IN = sum(NUMBER_HEAD_IN),
    NUMBER_HEAD_OUT = sum(NUMBER_HEAD_OUT),
    NUMBER_DAYS_ON = max(NUMBER_DAYS_ON)
  )
 # need to drop the Grazing_ID column to eliminate duplicates

# ##view(big_pasture) # - duplicates

glimpse(big_pasture)

big_pasture <- big_pasture |>
  select(
    PASTURE,
    grazing_year,
    GRAZABLE_ACRES,
    TOTAL_LBS_IN,
    TOTAL_LBS_OUT,
    TOTAL_GAIN,
    NUMBER_DAYS_ON,
    NUMBER_HEAD_IN,
    NUMBER_HEAD_OUT,
    TOTAL_LBS_IN,
    TOTAL_LBS_OUT,
    TOTAL_GAIN
  )

big_pasture <- distinct(big_pasture) # - remove duplicates

# ##view(big_pasture) # - no duplicates

#################
#
# Step 3 - # need to remove gas house and west branch 
#   records from original data
#
#################


orig_data <- orig_data |>
  filter(
    Pasture_ID != "Ga",
    Pasture_ID != "WB"
    ) 

#################
#
# Step 4a - load csv file from MultiGrazingStocking1.29.accdb
#  filter out bison and fix missing ActualDaysOn
#   
#################


multi_data <- read_csv("qryexp_MultiGrazing_All.csv")

glimpse(multi_data)

#view(multi_data)

# remove bison

multi_data <- multi_data |>
  filter(
    AnimalTypeID != "Bi"
  ) |>
  mutate(
    grazing_year = as.numeric(format(as.Date(LoadInDate, format = "%m/%d/%Y"), "%Y"))
  )

glimpse(multi_data)

#view(multi_data)

#################
#
# Step 4b - populate missing ActualDaysOn in multi database records
#  using days_diff
#   
#################


# populate missing ActualDaysOn in multi database records


multi_data_w_zeros <- multi_data |>
  filter(
    ActualDaysOn == 0
  )

multi_data_w_o_zeros <- multi_data |>
  filter(
    ActualDaysOn != 0
  )


multi_data_w_zeros <- multi_data_w_zeros |>
  mutate(
    date1 = as.Date(LoadInDate, format = "%m/%d/%Y"),
    date2 = as.Date(LoadOutDate, format = "%m/%d/%Y"),
    days_diff = difftime(date2, date1),
    ActualDaysOn = as.numeric(days_diff),
  )


glimpse(multi_data)

#view(multi_data)


multi_data <- bind_rows(multi_data_w_o_zeros, multi_data_w_zeros)

glimpse(multi_data)

#view(multi_data)





#################
#
# Step 5a - clean up all column names so they match 
#  and can be combined
#   
#################


orig_data <- orig_data |>
  mutate(
    pasture = PASTURE,
    acres = GRAZABLE_ACRES,
    grazing_year = Year,
    load_date_in = DATE_IN2,
    load_date_out = DATE_OUT2,
    goal_days_on = PRESCRIBED_DAYS,
    actual_days_on = NUMBER_DAYS_ON,
    head_on = NUMBER_HEAD_IN,
    head_off = NUMBER_HEAD_OUT,
    lbs_on = TOTAL_LBS_IN,  
    lbs_off = TOTAL_LBS_OUT
  ) |>
  select(pasture, acres, grazing_year, load_date_in, load_date_out, actual_days_on,
         head_on, head_off, lbs_on, lbs_off)
 
big_pasture <- big_pasture |>
   mutate(
     pasture = PASTURE,
     acres = GRAZABLE_ACRES,
     actual_days_on = NUMBER_DAYS_ON,
     head_on = NUMBER_HEAD_IN,
     head_off = NUMBER_HEAD_OUT,
     lbs_on = TOTAL_LBS_IN,  
     lbs_off = TOTAL_LBS_OUT
   ) |>
   select(pasture, acres, grazing_year, actual_days_on, head_on, head_off, lbs_on, lbs_off)

glimpse(big_pasture) 
  
multi_data <- multi_data |>
   mutate(
     pasture = PastureOriginal,
     acres = AcresOriginal,
     load_date_in = LoadInDate,
     load_date_out = LoadOutDate,
     goal_days_on = GoalDaysOn,
     actual_days_on = ActualDaysOn,
     head_on = HeadOn,
     head_off = HeadOff,
     lbs_on = LbsOn,
     lbs_off = LbsOff
   ) |>
   select(pasture, grazing_year, acres, load_date_in, load_date_out,
           actual_days_on, head_on, head_off, lbs_on, lbs_off)

view(multi_data) 

# weird values for Crush Hill and Red House (see below)

# write_xlsx(multi_data, "Multigrazing_dataframe.xlsx")

#date1 = as.Date(load_date_in, format = "%m/%d/%Y"),
#grazing_year = format(as.Date(load_date_in, format = "%m/%d/%Y"), "%Y"),
#date2 = as.Date(load_date_out, format = "%m/%d/%Y"),
#days_diff = difftime(date2, date1),


#view(orig_data)

view(multi_data) # no actual_days_on

single_values <- multi_data |>
  filter(
    (pasture == "Big") | (pasture == "East Traps and Two Section") 

  ) 

view(single_values)



#################
#
# Step 5b - combine (sum) multiple values in Crusher Hill and Red House
#   for 2022 and 2023 in multi_data
#   NOTE: Unexplained high values for Crusher Hill and Red House 
#   in 2022 and 2023 so these were omitted for the current report
#   
#################

RedHouse_values <- multi_data |>
  filter(
    pasture == c("Red House")
  ) 

#view(RedHouse_values)

RedHouse_values2 <- RedHouse_values |> 
  group_by(grazing_year) |>
  summarize(
    sum_days_on = sum(actual_days_on),
    sum_head_on = sum(head_on),
    sum_head_off = sum(head_off),
    sum_lbs_on = sum(lbs_on),
    sum_lbs_off = sum(lbs_off)
  ) 

#view(RedHouse_values2)

RedHouse_values3 <- RedHouse_values |>
  left_join(RedHouse_values2)

#view(RedHouse_values3) 

RedHouse_values4 <- RedHouse_values3 |>
  select(
    pasture, grazing_year, acres, sum_days_on, sum_head_on, 
    sum_head_off, sum_lbs_on, sum_lbs_off
    )

#view(RedHouse_values4) 

RedHouse_values5 <- RedHouse_values4 |>
  mutate(
    actual_days_on = sum_days_on,
    head_on = sum_head_on,
    head_off = sum_head_off,
    lbs_on = sum_lbs_on,
    lbs_off = sum_lbs_off
  ) |>
  distinct() |>
  select(pasture, grazing_year, acres, 
         actual_days_on, head_on, head_off, 
         lbs_on, lbs_off)

#view(RedHouse_values5)

###############

CrusherHill_values <- multi_data |>
  filter(
    pasture == c("Crusher Hill")
  ) 

#view(CrusherHill_values)

CrusherHill_values2 <- CrusherHill_values |> 
  group_by(grazing_year) |>
  summarize(
    sum_days_on = sum(actual_days_on),
    sum_head_on = sum(head_on),
    sum_head_off = sum(head_off),
    sum_lbs_on = sum(lbs_on),
    sum_lbs_off = sum(lbs_off)
  ) 

#view(CrusherHill_values2)

CrusherHill_values3 <- CrusherHill_values |>
  left_join(CrusherHill_values2)

#view(CrusherHill_values3) 

CrusherHill_values4 <- CrusherHill_values3 |>
  select(
    pasture, grazing_year, acres, sum_days_on, sum_head_on, 
    sum_head_off, sum_lbs_on, sum_lbs_off
  )

#view(CrusherHill_values4) 

CrusherHill_values5 <- CrusherHill_values4 |>
  mutate(
    actual_days_on = sum_days_on,
    head_on = sum_head_on,
    head_off = sum_head_off,
    lbs_on = sum_lbs_on,
    lbs_off = sum_lbs_off
  ) |>
  distinct() |>
  select(pasture, grazing_year, acres, 
         actual_days_on, head_on, head_off, 
         lbs_on, lbs_off)

#view(CrusherHill_values5)

###################

#view(RedHouse_values5)

RedHouse_values <- RedHouse_values5

CrusherHill_values <- CrusherHill_values5

###########################################
# Omitted Crusher Hill and Red House at this step
###########################################

# multi_data <- bind_rows(RedHouse_values, CrusherHill_values)

# view(multi_data)

# bind_rows(single_values, multi_data)

multi_data <- single_values

orig_data <- orig_data |>
  select( 
      pasture, acres, grazing_year, actual_days_on, head_on, head_off,
      lbs_on, lbs_off
    )


grazing_data <- bind_rows(orig_data, multi_data) 

glimpse(grazing_data) 

view(grazing_data) 



#################
#
# Step 6 - Do grazing calculations for all data
#   EXCEPT big pasture from gas house and west branch
#
#################




grazing_calc <- grazing_data |>
  mutate(
    #ave_animal_weight = lbs_on / head_on,
    aue = lbs_on / 1000,
    months = as.numeric( actual_days_on / 30),
    aum = aue*months,
    stocking_rate = aum / acres,
    acres_sr = acres / aum
  ) |>
  select(
    pasture, acres, grazing_year, actual_days_on, head_on, head_off, lbs_on, lbs_off, 
    aue, months, aum, stocking_rate, acres_sr
         )



#view(grazing_calc) 

glimpse(grazing_calc)

#################
#
# Step 7 - Do grazing calculations for 
#    big pasture from gas house and west branch
#
#################


grazing_calc_bp <- big_pasture |>
  mutate(
    ave_animal_weight = lbs_on / head_on,
    aue = lbs_on / 1000,
    months = (actual_days_on / 30),
    aum = aue*months,
    stocking_rate = aum / acres,
    acres_sr = acres / aum
  )

glimpse(grazing_calc_bp)

#view(grazing_calc_bp)  

glimpse(grazing_calc) 

view(grazing_calc) # missing actual_days_on


#################
#
# Step 8 - Combine big_pasture 
#    with the rest of the data
#
#################

grazing_final = bind_rows(grazing_calc, grazing_calc_bp)

view(grazing_final) 
glimpse(grazing_final)

write_xlsx(grazing_final, "Grazing_calculations_final.xlsx")

