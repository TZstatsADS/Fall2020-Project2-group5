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
source("global_citina.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })

})








