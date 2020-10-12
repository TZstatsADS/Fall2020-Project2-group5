#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

dashboardPage(
    skin = "purple",
    dashboardHeader(title = "COVID 19 in the U.S"),
    dashboardSidebar(sidebarMenu(
        menuItem("Home", tabName = "Home", icon = icon("dashboard")),
        menuItem("MAP", tabName = "MAP", icon = icon("map")),
        menuItem("SEARCH BY STATE", tabName = "SEARCH", icon = icon("flag-usa")),
        menuItem("DATA SOURCE", tabName = "DATASOURCE", icon = icon("cloud-download"))
    )),
    dashboardBody(fill = FALSE,tabItems(
        #-------------------tab1 Home
        
        #-------------------tab2 Map
        
        #-------------------tab3 Search Panel
        tabItem(tabName = "SEARCH",
                fluidPage()
                
                
                
                
                ),
        
        #-------------------tab4 Data Source
        tabItem(tabName = "Data Source",
                fluidPage(
                    HTML(
                    "<h2> Data Source : </h2>
                    <h4> <p><li><a href='https://coronavirus.jhu.edu/map.html'>Coronavirus COVID-19 Global Cases map Johns Hopkins University</a></li></h4>
                    <h4><li>COVID-19 Cases : <a href='https://github.com/CSSEGISandData/COVID-19' target='_blank'>Github Johns Hopkins University</a></li></h4>
                    <h4><li>Spatial Polygons : <a href='https://www.naturalearthdata.com/downloads/' target='_blank'> Natural Earth</a></li></h4>"
                )
                )
                )
    ))
)

