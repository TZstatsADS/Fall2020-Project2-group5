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
        tabItem(tabName = "MAP"
                
                
                
                ),
        
        #-------------------tab3 Search Panel
        tabItem(tabName = "SEARCH",
                fluidPage(
                    fluidRow(
                        column(4,
                               selectInput('state1', 'State 1', state.name, selectize=TRUE)
                        ),
                        column(4,
                               selectInput('state2', 'State 2', c(Choose='', state.name), selectize=TRUE)
                        )),
                    fluidRow(box(width = 12,title = "", 
                                 plotlyOutput("death_plt")))
                    
                )
                ),
        
        #-------------------tab4 Data Source
        tabItem(tabName = "DATA SOURCE",
               
                )
    ))
)

