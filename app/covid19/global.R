#------------------------------this code is used to update the data daily---------------------------------
# packages used
packages.used <- 
  as.list(c("tidyverse", "haven", "plotly", "shiny", "ggplot2", "shinythemes", "tmap", "sf", 
            "rgdal", "RColorBrewer","tibble", "viridis", "RCurl", "leaflet", "zoo", "lubridate",
            "RColorBrewer"))

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
library(tmap)
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

# read up to date data from JHU
urlpart1 <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/"
start <- as.Date("2020-04-12")

if(month(start)<10){
  if(day(start)<10){
    df <- read.csv(text = getURL(paste0(urlpart1, '0', month(start), "-", '0', day(start), "-", year(start), ".csv")))
  }else{
    df <- read.csv(text = getURL(paste0(urlpart1, '0', month(start), "-", day(start), "-", year(start), ".csv")))
  }
}else{
  if(day(start)<10){
    df <- read.csv(text = getURL(paste0(urlpart1, month(start), "-", '0', day(start), "-", year(start), ".csv")))
  }else{
    df <- read.csv(text = getURL(paste0(urlpart1, month(start), "-", day(start), "-", year(start), ".csv")))
  }
}
  
for (i in (start+1):(Sys.Date()-1)) {
  t <- as.Date(i)
  if(month(t)<10){
    if(day(t)<10){
      temp <- read.csv(text = getURL(paste0(urlpart1, '0', month(t), "-", '0', day(t), "-", year(t), ".csv")))
    }else{
      temp <- read.csv(text = getURL(paste0(urlpart1, '0', month(t), "-", day(t), "-", year(t), ".csv")))
    }
  }else{
    if(day(t)<10){
      temp <- read.csv(text = getURL(paste0(urlpart1, month(t), "-", '0', day(t), "-", year(t), ".csv")))
    }else{
      temp <- read.csv(text = getURL(paste0(urlpart1, month(t), "-", day(t), "-", year(t), ".csv")))
    }
  }
  df <- rbind(df, temp)
}

df_clean <- df %>% 
  mutate(Last_Update = as.Date(Last_Update)) %>% 
  filter(ISO3 == 'USA') %>% 
  filter(FIPS < 100) %>% 
  droplevels() %>% 
  mutate(Recovered=ifelse(is.na(Recovered), 0, Recovered))

tmpc <- which(df_clean$Active<0)
df_clean$Active[tmpc] <- round(mean(c(df_clean$Active[tmpc-1], df_clean$Active[tmpc+1])),0)

# save(df_clean, file="output/data_up_to_date.RData")
#load("output/data_up_to_date.RData")
# there are 50 states and District of Columbia

# if the data source is not available, will use the data stored (up to 10-08-2020)
# name: "data_use.Rdata"

cbPalette <- c("#56B4E9", "#D55E00", "#009E73", "#F0E442", "#E69F00", "#0072B2", "#CC79A7", "#F0E449")














