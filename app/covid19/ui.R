#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

dashboardPage(
    skin = "purple",
    dashboardHeader(title = "COVID-19 in the U.S."),
    dashboardSidebar(sidebarMenu(
        menuItem("HOME", tabName = "HOME", icon = icon("dashboard")),
        menuItem("MAP", tabName = "MAP", icon = icon("map")),
        menuItem("SEARCH", tabName = "SEARCH", icon = icon("flag-usa")),
        menuItem("DATA SOURCE", tabName = "DATA SOURCE", icon = icon("cloud-download"))
    )),
    dashboardBody(fill = FALSE,tabItems(
        #-------------------tab1 Home
        tabItem(tabName = "HOME"
                
                
                
                ),
        #-------------------tab2 Map
        tabItem(tabName = "MAP",
                fluidRow(
                    box('Map', width=9, status='primary',
                        leafletOutput('drawmap', height=750)
                    ),
                    box(width = 3, status='info',
                        dateInput('DateInput', label = 'Select Date Range',
                                  min=mindate, max=maxdate, 
                                  value = mindate),
                        selectInput('IndicatortInput', label = 'Select Indicator',
                                    choices=Indicators)
                    )
                )
                
                
                ),
        
        #-------------------tab3 Search Panel
        tabItem(tabName = "SEARCH",
                fluidPage(
                    checkboxGroupInput("state1", "Choose Category:",
                                             choices = c("California", "New York"),
                                             selected = c("California")
                           ),
                          fluidRow(column(width=12, title='Deaths over time',
                                          plotlyOutput("death_plt")))
                    
                )),
        
        #-------------------tab4 Data Source
        tabItem(tabName = "DATA SOURCE",
               
                )
    ))
)

