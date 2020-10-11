# packages used
packages.used <- 
  as.list(c("tidyverse", "haven", "plotly", "shiny", "ggplot2", "shinythemes", "tmap", "sf", 
            "rgdal", "RColorBrewer","tibble", "viridis", "RCurl", "leaflet"))

# require and install packages
check.pkg <- function(x){
  if(!require(x, character.only=T)) 
    install.packages(x, character.only=T, dependence=T)
}

lapply(packages.used, check.pkg)

# 

#can run RData directly to get the necessary date for the app
#global.r will enable us to get new data everyday
#update data with automated script
source("global.R") 
#load('./output/covid-19.RData')
