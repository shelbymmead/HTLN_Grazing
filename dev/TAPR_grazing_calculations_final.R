
#################################################################
#
#  TAPR_grazing_calculationsV2.R
#
#  Gareth Rowell, 6/28/2024
#
#  Revised grazing stocking calculations using data 
#    from GrazingStocking3.53.accdb and
#    MultiGrazingStocking1.29.accdb
#
#
##################################################################



library(tidyverse)
library(writexl)

setwd("C:/Users/growell/TAPR-grazing/src")

#################---------------------------------------------------
#
# Step 1 - load .csv file from GrazingStocking3.52.accdb
#   and filter out NAs in date out and 0's in total lbs out.
#
#################

orig_data <-  read_csv("qryexp_Grazing_corr.csv")

problems(orig_data)

glimpse(orig_data)

view(orig_data)

# filter out records with NA in DATE_OUT and total lbs out that are zero

orig_data <- orig_data |>
              filter((TOTAL_LBS_OUT > 0)&(!is.na(NUMBER_DAYS_ON))&(TOTAL_LBS_IN > 0))

glimpse(orig_data)

#view(orig_data)

################# SKIP gas house and west branch --
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

#ga_wb_data <- orig_data |>
#  filter((Pasture_ID == "Ga")|(Pasture_ID == "WB")) |>
#  
#  mutate(
#    grazing_year = Year
#  )

#glimpse(ga_wb_data)

# ##view(ga_wb_data) #- no duplicates

# This reframe generates duplicate records for big pasture

#big_pasture <- ga_wb_data |>
#  group_by(grazing_year) |>
#  mutate(
#    Pasture_ID = "Bi",
#    PASTURE = "Big",
#    GRAZABLE_ACRES = sum(GRAZABLE_ACRES),
#    TOTAL_LBS_IN = sum(TOTAL_LBS_IN),
#    TOTAL_LBS_OUT = sum(TOTAL_LBS_OUT),
#    TOTAL_GAIN = sum(TOTAL_GAIN),
#    NUMBER_HEAD_IN = sum(NUMBER_HEAD_IN),
#    NUMBER_HEAD_OUT = sum(NUMBER_HEAD_OUT),
#    NUMBER_DAYS_ON = max(NUMBER_DAYS_ON)
#  )
 # need to drop the Grazing_ID column to eliminate duplicates

# ##view(big_pasture) # - duplicates

#glimpse(big_pasture)

#big_pasture <- big_pasture |>
#  select(
#    PASTURE,
#    grazing_year,
#    GRAZABLE_ACRES,
#    TOTAL_LBS_IN,
#    TOTAL_LBS_OUT,
#    TOTAL_GAIN,
#    NUMBER_DAYS_ON,
#    NUMBER_HEAD_IN,
#    NUMBER_HEAD_OUT,
#    TOTAL_LBS_IN,
#    TOTAL_LBS_OUT,
#    TOTAL_GAIN
#  )

#big_pasture <- distinct(big_pasture) # - remove duplicates

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

view(orig_data)

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

view(multi_data)





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
 
#big_pasture <- big_pasture |>
#   mutate(
#     pasture = PASTURE,
#     acres = GRAZABLE_ACRES,
#     actual_days_on = NUMBER_DAYS_ON,
#     head_on = NUMBER_HEAD_IN,
#     head_off = NUMBER_HEAD_OUT,
#     lbs_on = TOTAL_LBS_IN,  
#     lbs_off = TOTAL_LBS_OUT
#   ) |>
#   select(pasture, acres, grazing_year, actual_days_on, head_on, head_off, lbs_on, lbs_off)

#glimpse(big_pasture) 
  
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

# cut out all the code for Crusher and Red House 2022 - 2023
# and used spreadsheet
# calculations from Sherry's spreadsheet

###########################################
# Omitted Crusher Hill and Red House at this step
# by commenting out next line
###########################################

# multi_data <- bind_rows(RedHouse_values, CrusherHill_values)

# view(multi_data)

# bind_rows(single_values, multi_data)

# multi_data <- single_values

orig_data <- orig_data |>
  select( 
      pasture, acres, grazing_year, actual_days_on, head_on, head_off,
      lbs_on, lbs_off
    )

view(orig_data)
view(multi_data)


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
    months = as.numeric( actual_days_on / 30),
	ave_no_head = ((head_on + head_off) / 2),
    ave_wt_on = lbs_on / head_on,
	ave_wt_off = lbs_off / head_off,
	ave_wt = (ave_wt_on + ave_wt_off) / 2,
	AUE1 = (ave_wt_off - ave_wt_on) / 2,
	AUE2 = (AUE1 + ave_wt_on) / 1000,
	AUM_per_head = AUE2 * months,
	Total_AUM = ave_no_head * AUM_per_head,
	Stocking_AUM_per_Acre = Total_AUM / acres,
	Stocking_Acres_per_AUM = 1 / Stocking_AUM_per_Acre,
	Total_AUY = Total_AUM / 12,
	Acres_per_AUY = acres / Total_AUY
  ) |>
  select(
    pasture, acres, grazing_year, actual_days_on, head_on, head_off, lbs_on, lbs_off, 
    months, ave_no_head,ave_wt_on, ave_wt_off, ave_wt,
	AUE1, AUE2, AUM_per_head, Total_AUM,
	Stocking_AUM_per_Acre, Stocking_Acres_per_AUM,
	Total_AUY, Acres_per_AUY
    )
 

#view(grazing_calc) 

glimpse(grazing_calc)

################# skipping this stuff
#
# Step 7 - Do grazing calculations for 
#    big pasture from gas house and west branch
#
#################


#grazing_calc_bp <- big_pasture  |>
#  mutate(
#    months = as.numeric( actual_days_on / 30),
#	ave_no_head = ((head_on + head_off) / 2),
#    ave_wt_on = lbs_on / head_on,
#	ave_wt_off = lbs_off / head_off,
#	ave_wt = (ave_wt_on + ave_wt_off) / 2,
#	AUE1 = (ave_wt_off - ave_wt_on) / 2,
#	AUE2 = (AUE1 + ave_wt_on) / 1000,
#	AUM_per_head = AUE2 * months,
#	Total_AUM = ave_no_head * AUM_per_head,
#	Stocking_AUM_per_Acre = Total_AUM / acres,
#	Stocking_Acres_per_AUM = 1 / Stocking_AUM_per_Acre,
#	Total_AUY = Total_AUM / 12,
#	Acres_per_AUY = acres / Total_AUY
 # ) |>
#  select(
#    pasture, acres, grazing_year, actual_days_on, head_on, head_off, lbs_on, lbs_off, 
#    months, ave_no_head,ave_wt_on, ave_wt_off, ave_wt,
#	AUE1, AUE2, AUM_per_head, Total_AUM,
#	Stocking_AUM_per_Acre, Stocking_Acres_per_AUM,
#	Total_AUY, Acres_per_AUY
 #   )
 

#glimpse(grazing_calc_bp)

#view(grazing_calc_bp)  

#glimpse(grazing_calc) 

#view(grazing_calc) 


#################
#
# Step 8 - Combine big_pasture 
#    with the rest of the data
#
#################

#grazing_final = bind_rows(grazing_calc, grazing_calc_bp)

grazing_final <- grazing_calc

view(grazing_final) 
glimpse(grazing_final)

write_xlsx(grazing_final, "Grazing_calculations_final.xlsx")

