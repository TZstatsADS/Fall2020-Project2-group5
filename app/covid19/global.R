#------------------------------this code is used to update the data daily---------------------------------
# packages used
packages.used <- 
  as.list(c("tidyverse", "haven", "plotly", "shiny", "ggplot2", "shinythemes", "tmap", "sf", 
            "rgdal", "RColorBrewer","tibble", "viridis", "RCurl", "leaflet", "zoo", "lubridate",
            "RColorBrewer", "maps","leaflet.extras","htmltools", "shinyWidgets"))

# require and install packages
check.pkg <- function(x){
  if(!require(x, character.only=T)) 
    install.packages(x, character.only=T, dependence=T)
}

lapply(packages.used, check.pkg)

library(viridis)
library(dplyr)
library(tibble)
library(tidyverse)
library(shinythemes)
library(sf)
library(RCurl)
#library(tmap)
library(rgdal)
library(leaflet)
library(shiny)
library(shinythemes)
library(plotly)
library(ggplot2)
library(lubridate)
library(zoo)
library(shinydashboard)
library(RColorBrewer)
library(htmltools)
library(leaflet.extras)
library(maps)
library(shinyWidgets)

# read up to date data from JHU
# urlpart1 <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/"
# start <- as.Date("2020-04-12")
# 
# if(month(start)<10){
#   if(day(start)<10){
#     df <- read.csv(text = getURL(paste0(urlpart1, '0', month(start), "-", '0', day(start), "-", year(start), ".csv")))
#   }else{
#     df <- read.csv(text = getURL(paste0(urlpart1, '0', month(start), "-", day(start), "-", year(start), ".csv")))
#   }
# }else{
#   if(day(start)<10){
#     df <- read.csv(text = getURL(paste0(urlpart1, month(start), "-", '0', day(start), "-", year(start), ".csv")))
#   }else{
#     df <- read.csv(text = getURL(paste0(urlpart1, month(start), "-", day(start), "-", year(start), ".csv")))
#   }
# }
#   
# for (i in (start+1):(Sys.Date()-1)) {
#   t <- as.Date(i)
#   if(month(t)<10){
#     if(day(t)<10){
#       temp <- read.csv(text = getURL(paste0(urlpart1, '0', month(t), "-", '0', day(t), "-", year(t), ".csv")))
#     }else{
#       temp <- read.csv(text = getURL(paste0(urlpart1, '0', month(t), "-", day(t), "-", year(t), ".csv")))
#     }
#   }else{
#     if(day(t)<10){
#       temp <- read.csv(text = getURL(paste0(urlpart1, month(t), "-", '0', day(t), "-", year(t), ".csv")))
#     }else{
#       temp <- read.csv(text = getURL(paste0(urlpart1, month(t), "-", day(t), "-", year(t), ".csv")))
#     }
#   }
#   df <- rbind(df, temp)
# }
# 
# df_clean <- df %>% 
#   mutate(Last_Update = as.Date(Last_Update)) %>% 
#   filter(ISO3 == 'USA') %>% 
#   filter(FIPS < 100) %>% 
#   droplevels() %>% 
#   mutate(Recovered=ifelse(is.na(Recovered), 0, Recovered))
# 
# tmpc <- which(df_clean$Active<0)
# df_clean$Active[tmpc] <- round(mean(c(df_clean$Active[tmpc-1], df_clean$Active[tmpc+1])),0)

# adding population variable:
# df_add <- read.csv(text = getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv"))
# df_clean <- 
#   df_add %>% 
#   select(FIPS, Population) %>% 
#   merge(df_clean, by='FIPS')

# save(df_clean, file="output/data_up_to_date.RData")
# there are 50 states and District of Columbia

# if the data source is not available, will use the data stored (up to 10-11-2020)
# name: "data_up_to_date.Rdata"
load(file = "output/data_up_to_date.RData")
cbPalette <- c("#56B4E9", "#D55E00", "#009E73", "#F0E442", "#E69F00", "#0072B2", "#CC79A7", "#F0E449")

#--------map
load("output/data_up_to_date.RData")
data = df_clean

date = data$Last_Update %>% unique()
mindate = date[1]
maxdate = date[length(date)]
Indicators = colnames(data)[c(6:9,11:14,17,18)]

data = data %>% 
  mutate(Province_State = as.character(Province_State))

draw_map = function(df, indicator){
  mapusa = maps::map("state", fill = TRUE, plot = FALSE)
  
  Names = tibble(State = mapusa$names) %>%
    group_by(State) %>% mutate(Name = strsplit(State,':')[[1]][1])
  
  df = df %>%
    right_join(Names, by = c('Province_State' = 'Name'))
  
  state = c(unlist(df['Province_State']))
  values <- c(unlist(df['Value']))
  
  
  if(indicator %in% colnames(data)[c(11,14,18)])
    labels = sprintf("%s<br/>%s:%g%%", str_to_upper(state), indicator, signif(values,4))
  else
    labels = sprintf("%s<br/>%s:%g", str_to_upper(state), indicator, signif(values,4))
  labels = labels %>%
    lapply(htmltools::HTML)
  pal <- colorBin("YlOrRd", domain = values, bins = 9)
  
  print(labels)
  
  leaflet(data = mapusa) %>% 
    setView(-96, 37.8, 5) %>%
    addTiles() %>%
    addResetMapButton() %>% 
    addPolygons(
      fillColor = pal(values),
      weight = 2, 
      opacity = 1, 
      color='white',
      dashArray = 3,
      fillOpacity = .7,
      highlight = highlightOptions(
        weight = 5,
        color = "#666",
        dashArray = "",
        fillOpacity = .75,
        bringToFront = T
      ),
      label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", 'padding' = "10px 15px"),
        textsize = "15px",
        direction = "auto")
    ) %>%  
    addLegend(pal = pal,
              values = values,
              opacity = 0.85,
              title = NULL,
              position = "bottomright")
}


#-------Search Panel
df_avg <- 
  df_clean %>% 
  group_by(Last_Update) %>% 
  summarise(total_deaths=floor(mean(Deaths)),
            total_active=floor(mean(Active)),
            total_confirmed=floor(mean(Confirmed)),
            total_recovered=floor(mean(Recovered)),
            Population=floor(mean(Population)),
            prect_deaths=total_deaths/Population,
            prect_active=total_active/Population,
            prect_confirmed=total_confirmed/Population,
            prect_recovered=total_recovered/Population,
            People_Tested=floor(mean(People_Tested)),
            Incident_Rate=floor(mean(Incident_Rate))) %>% 
  mutate(Province_State = factor('Average')) %>% 
  select(Province_State, Last_Update, total_deaths, 
         total_active, total_confirmed, total_recovered,
         Population, prect_deaths, prect_active, prect_confirmed,
         prect_recovered, People_Tested, Incident_Rate)


df_plt <- 
  df_clean %>% 
  group_by(Province_State, Last_Update) %>% 
  summarise(total_deaths=sum(Deaths),
            total_active=sum(Active),
            total_confirmed=sum(Confirmed),
            total_recovered=sum(Recovered),
            Population=Population,
            People_Tested=People_Tested,
            Incident_Rate=floor(Incident_Rate),
            prect_deaths=total_deaths/Population,
            prect_active=total_active/Population,
            prect_confirmed=total_confirmed/Population,
            prect_recovered=total_recovered/Population) %>% 
  as.data.frame() %>%
  rbind(df_avg)











