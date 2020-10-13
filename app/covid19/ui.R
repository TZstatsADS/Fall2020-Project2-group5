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
                fluidPage(
                    fluidRow(leafletOutput('drawmap', height=750)),
                    fluidRow(absolutePanel(top = 100, right = 20,
                        dateInput('DateInput', label = 'Select Date',
                                  min=mindate, max=maxdate, 
                                  value = mindate),
                        selectInput('IndicatortInput', label = 'Select Indicator',
                                    choices=Indicators)
                        )
                    )
                )
                
        ),
        
        #-------------------tab3 Search Panel
        tabItem(tabName = "SEARCH",
                fluidRow(column(4, selectInput('state1', 'State 1', state.name, selectize=TRUE)),
                         column(4, selectInput('state2', 'State 2', c(Choose='', state.name), selectize=TRUE)),
                         br(),
                         column(4, switchInput('prect', '%'))
                ),
                
                # value boxes
                fluidRow(
                    valueBoxOutput('deaths_val'),
                    valueBoxOutput('confirmed_val'),
                    valueBoxOutput('active_val')
                ),
                fluidRow(
                    valueBoxOutput('recovered_val'),
                    valueBoxOutput('peopletested_val'),
                    valueBoxOutput('incidentrate_val')
                ),
                
                br(),
                
                # plots
                mainPanel(
                    width = '100%',
                    tabsetPanel(type = 'tabs',
                                tabPanel('Deaths', plotlyOutput('death_plt')),
                                tabPanel('Confirmed', plotlyOutput('confirmed_plt')),
                                tabPanel('Active', plotlyOutput('active_plt')),
                                tabPanel('Recovered', plotlyOutput('recovered_plt')),
                                tabPanel('Incident Rate', plotlyOutput('incidentrate_plt'))
                    )
                )
        ),
        
        #-------------------tab4 Data Source
        tabItem(tabName = "DATA SOURCE",
                
        )
    ))
)



