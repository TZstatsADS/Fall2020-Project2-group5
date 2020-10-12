#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# packages used
packages.used <- 
    as.list(c("tidyverse", "haven", "plotly", "shiny", "ggplot2", "shinythemes", "tmap", "sf", 
              "rgdal", "RColorBrewer","tibble", "viridis", "RCurl", "leaflet", "zoo", "lubridate"))

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

# load data
#load("www/df_up_to_date.Rdata")
source("global_citina.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    #-------------------tab1 Home
    
    #-------------------tab2 Map
    
    #-------------------tab3 Search Panel
    
    
    
    
    
    
    
    
    
    
    #-------------------tab4 Data Source
    

})








