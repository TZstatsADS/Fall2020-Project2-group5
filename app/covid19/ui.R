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
        menuItem("ABOUT", tabName = "ABOUT", icon = icon("cloud-download"))
    )),
    dashboardBody(fill = FALSE,tabItems(
        #-------------------tab1 Home
        tabItem(tabName = "HOME",
                fluidRow(
                    valueBoxOutput("total_case"),
                    valueBoxOutput("total_recovered"),
                    valueBoxOutput("total_death"))),
        
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
                         column(4, switchInput('prect', '%')) #switch button
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
        
        #-------------------tab4 About
        tabItem(tabName = "ABOUT",
                fluidPage(
                    mainPanel( width=12,
                               plotOutput('cases_cald'),
                               h1(strong("What you'll find here"),align = "center"),
                               column(12,
                                      tags$ul(
                                          tags$li(h4("In this project, we designed a shiny app with information about covid-19 in US." )), 
                                          tags$li(h4("By covid 19 us shiny app, we can easily find the information about the US cases spread map,state to state comparison,daily update of the cases,etc."))
                                      )
                               ),
                               br(),
                               h1(strong("About the Data"),align = "center"),
                               column(12,
                                      h4(" We used the date data from JHU.This dataset contains daily updated data of confirmed cases, recovered cases,deaths cases,test,hospitaliaztion information.
                         The data is from Arp.12,2020 to Ocb.11,2020. We just keep 50 states and District of Columbia data for further exploration."),
                                      hr(),
                                      
                                      ),
                               br(),
                               column(12,
                                      h1(strong("About the team"),align = "center"),
                                      h4("The covid-19 US Spread App is creadted by
                           Citina Liang, Henan Xu, and Xiangning Han." ,align = "center"),
                                      br(),br()
                               )),
                ),
                
        )
        
    ))
)



