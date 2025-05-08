Tallgrass Prairie National Preserve sends HTLN grazing data every year to file in an Access database and generate reports to analyze how stocking rate and AUY is changing over time on different pastures within the park. This script will conduct analysis
on data exported from the database starting in 2024 and join it to analysis previously conducted on pre-2024 data. Data pre-2024 was stored in two seperate databases and had a number of problems, modifications, and by-hand calculations that made it impossible
to replicate analysis for those years. However, going forward data can be pulled from the current Access database and run through this Rmd script to create calculated values and graphs for the entire project history. 
Instructions on running this code can be found.

Data imported from Access database:
Pasture (unit),
Grazing Year,
Acres,
In date,
Out date,
Actual days on ,
Head on,
Head off,
Lbs on, and
Lbs off

Calculated elements:

$Months = \text{actual days on}\div 30$

$\text{Ave number of head} = (\text{head on} + \text{head off}) \div 2$

$\text{Ave Wt on} = \text{lbs on} \div \text{head on}$

$\text{Ave Wt off}= \text{lbs off} \div \text{head off}$

$\text{Ave Wt} = (\text{Ave Wt on} + \text{Ave Wt off}) \div 2$

$\text{AUE1 (step 1)} = (\text{Ave Wt off} – \text{Ave Wt on}) \div 2$

$\text{AUE2 (step2)} = (AUE1 + \text{Ave Wt on}) \div 1000$

$AUMperHead = AUE2 \times Months$

$TotalAUM = \text{Ave number of head} \times AUMperHead$

$Stocking(AUM/Acre) = TotalAUM \div Acres$

$Stocking(Acres/AUM) = 1 \div Stocking(AUM/Acre)$

$Total AUY = TotalAUM\div 12$

$Acres/AUY= acres \div Total AUY$

For pastures with multiple grazing events in the same year

If unit >1 load in date/year, AggregateStocking(AUM/acre) =sum Stocking(AUM/Acre) values for the year.  And for AggregateStocking(acres/AUM) = 1/summed stocking(Aum/Acre)
