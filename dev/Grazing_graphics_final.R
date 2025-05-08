


################################################################################
#
#  Grazing_graphics.R
#
#  Gareth Rowell, 5/22/2024
#
#  Figures and graphs for TAPR grazing
#
################################################################################


library(tidyverse)
library(ggplot2)

setwd("C:/Users/Growell/TAPR-grazing/src")

grazing_calc <- read_csv("Grazing_calculations_final_RHCr_corr.csv")

problems(grazing_calc)


view(grazing_calc)

glimpse(grazing_calc)

# histograms

# months
ggplot(grazing_calc, aes(x = months)) +
  geom_histogram(binwidth = 0.5)
  
ggsave("months.jpeg")


# ave_no_head
ggplot(grazing_calc, aes(x = ave_no_head)) +
  geom_histogram(binwidth = 50)
  
ggsave("ave_no_head.jpeg")


# ave_wt_on
ggplot(grazing_calc, aes(x = ave_wt_on)) +
  geom_histogram(binwidth = 50)
  
ggsave("ave_wt_on.jpeg")


# ave_wt_off
ggplot(grazing_calc, aes(x = ave_wt_off)) +
  geom_histogram(binwidth = 50)
  
ggsave("ave_wt_off.jpeg")









# dots actual black and slightly bigger
# labels without _
# need unit - rate AUM / acre
# grazing_year -> Year
# 

# Arial font <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Axes as 12 pt font ----------- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


ggplot(grazing_calc, aes(x = grazing_year, y = Stocking_Acres_per_AUM)) + 
  geom_point(size = 1.75) + 
  facet_wrap(~ pasture) + 
  labs(x = "Year", y = "Stocking Rate (Acres/AUM)") +
  theme(axis.title.y = element_text(size = 12, face = "bold")) +
  theme(axis.title.x = element_text(size = 12, face = "bold")) +
  theme(strip.text = element_text(face = "bold")) 

ggsave("FacetWrap_StockingRate.jpeg")




# Stocking acres per AUM


ggplot(grazing_calc, aes(x = grazing_year, y = Stocking_Acres_per_AUM)) + 
  geom_point(size = 1.75) + 
  facet_wrap(~ pasture) + 
  labs(x = "Year", y = "Stocking Rate (acre/AUM)") +
  theme(axis.title.y = element_text(size = 12, face = "bold")) +
  theme(axis.title.x = element_text(size = 12, face = "bold")) +
  theme(strip.text = element_text(face = "bold")) 

ggsave("FacetWrap_Acres_StockingRate.jpeg")



# Total AUY


ggplot(grazing_calc, aes(x = grazing_year, y = Total_AUY)) + 
  geom_point(size = 1.75) + 
  facet_wrap(~ pasture) + 
  labs(x = "Year", y = "Total AUY") +
  theme(axis.title.y = element_text(size = 12, face = "bold")) +
  theme(axis.title.x = element_text(size = 12, face = "bold")) +
  theme(strip.text = element_text(face = "bold")) 

ggsave("FacetWrap_Total_AUY.jpeg")


# Acres per AUY


ggplot(grazing_calc, aes(x = grazing_year, y = Acres_per_AUY)) + 
  geom_point(size = 1.75) + 
  facet_wrap(~ pasture) + 
  labs(x = "Year", y = "Total AUY") +
  theme(axis.title.y = element_text(size = 12, face = "bold")) +
  theme(axis.title.x = element_text(size = 12, face = "bold")) +
  theme(strip.text = element_text(face = "bold")) 

ggsave("FacetWrap_Acres_per_AUY.jpeg")







# dots actual black and slightly bigger
# labels without _
# need unit - rate AUM / acre
# grazing_year -> Year
# 


#ggplot(grazing_calc, aes(x = grazing_year, fill = stocking_rate)) +
#  geom_density(alpha = 0.5) +
#  facet_wrap(~ pasture)

ggplot(grazing_calc, aes(x = grazing_year, y = stocking_rate)) +
  geom_point() +
  geom_smooth(method = "lm")  + 
  labs(x = "Year", y = "Stocking Rate (AUM/acre)") +
  theme(axis.title.y = element_text(size = 12, face = "bold")) +
  theme(axis.title.x = element_text(size = 12, face = "bold")) +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank()) 

ggsave("LinearRegression_StockingRate.jpeg")

# clean up the above figure like facet figure
# remove gray background


#ggplot(grazing_calc, aes(x = pasture, y = stocking_rate)) +
#  geom_boxplot()


########## Stocking rate regression---------------------------------------------

head(grazing_calc)

attach(grazing_calc)


#fit simple linear regression model
model <- lm(stocking_rate ~ grazing_year)

#view model summary - R**2adj = 0.77

summary(model)

#define residuals
#res <- resid(model)

#produce residual vs. fitted plot
#plot(fitted(model), res)

#add a horizontal line at 0 
#abline(0,0)



# Plotting means and sds



grazing_msd <- grazing_calc |>                       
  group_by(grazing_year) |>
  summarize(
    ave_stocking_rate = mean(Stocking_Acres_per_AUM),
    sd = sd(Stocking_AUM_per_Acre)
  )

ggplot(grazing_msd, aes(x=grazing_year, y=ave_stocking_rate)) + 
  geom_errorbar(aes(ymin=ave_stocking_rate-sd, ymax=ave_stocking_rate+sd), width= 0) +
  geom_point(size=2) + 
  labs(x = "Year", y = "Stocking Rate (Acres/AUM)") +
  theme(axis.title.y = element_text(size = 14, face = "bold"),
        axis.title.x = element_text(size = 14, face = "bold"), 
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))


ggsave("MeansSDs_StockingRate.jpeg", dpi = 300, height = 5, width= 10)


view(grazing_calc)
view(grazing_msd)



# AUY panel


ggplot(grazing_calc, aes(x = grazing_year, y = Stocking_Acres_per_AUM)) + 
  geom_point(size = 1) + 
  facet_wrap(~ pasture) + 
  labs(x = "Year", y = "Stocking Rate (Acres/AUM)") +
  theme(axis.title.y = element_text(size = 12, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"), 
        strip.text = element_text(face = "bold", size = 11),
        axis.text.x = element_text(size = 10))

ggsave("FacetWrap_StockingRate.jpeg", dpi = 300, height = 5, width= 10))




























# clean up titles, point size 
# 12 pt point 


# Coeefficient of Variation ----------------------------------------------------


grazing_CV <- grazing_msd  |>
  mutate(
    CV_stocking_rate = sd / ave_stocking_rate
  )


ggplot(grazing_CV, aes(x = grazing_year, y = CV_stocking_rate)) +
  geom_point() +
  geom_smooth(method = "lm")


#regression model - R**2adj = 0.42

grazing_CV

head(grazing_CV)

attach(grazing_CV)


#fit simple linear regression model
model <- lm( CV_stocking_rate ~ grazing_year)

#view model summary R^2 = 0.42

summary(model)


#  Hoof action!! ---------------------------------------------------------------

grazing_ha <- grazing_calc |>
  mutate(
    hoof_action = head_on * 4
  )

ggplot(grazing_ha, aes(x = grazing_year, y = hoof_action)) +
  geom_point() +
  geom_smooth(method = "lm")

#regression model

grazing_ha

head(grazing_ha)

attach(grazing_ha)


#fit simple linear regression model
model <- lm( hoof_action ~ grazing_year)

#view model summary R^2 = 0.42

summary(model)


# additional analysis

# convert data to timeseries, using annual mean stocking rate
# vs year

# plot means, moving average and trendline (regression w/o CIs)











