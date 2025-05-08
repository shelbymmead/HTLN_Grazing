Tallgrass Prairie National Preserve sends HTLN grazing data every year to file in an Access database and generate reports to analyze how stocking rate and AUY is changing over time on different pastures within the park. This script will conduct analysis
on data exported from the database starting in 2024 and join it to analysis previously conducted on pre-2024 data. Data pre-2024 was stored in two seperate databases and had a number of problems, modifications, and by-hand calculations that made it impossible
to replicate analysis for those years. However, going forward data can be pulled from the current Access database and run through this Rmd script to create calculated values and graphs for the entire project history. 
Instructions on running this code can be found.

Data imported from Access database:
Pasture (unit)
Grazing Year
Acres
In date
Out date
Actual days on (not sure if you are calculating in R or if this is working properly in access)
Head on
Head off
Lbs on
Lbs off

Calculated elements:
Months = actual days on/30
Ave number of head = (head on + head off)/2
Ave Wt on = lbs on/head on
Ave Wt off = lbs off/head off
Ave Wt = (Ave Wt on + Ave Wt off)/2)
AUE1 (step 1) = (Ave Wt off – Ave Wt on)/2
AUE2 (step2) = (AUE1 + Ave Wt on)/1000
AUMperHead = AUE2*Months
TotalAUM = Ave number of head*AUMperHead
Stocking(AUM/Acre) = TotalAUM/Acres
Stocking(Acres/AUM) = 1/ Stocking(AUM/Acre)
Total AUY = Total AUM/12
Acres/AUY= acres/Total AUY
For pastures with multiple grazing events in the same year
If unit >1 load in date/year, AggregateStocking(AUM/acre) =sum Stocking(AUM/Acre) values for the year.  And for AggregateStocking(acres/AUM) = 1/summed stocking(Aum/Acre)
