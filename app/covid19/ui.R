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
        menuItem("Statistics analysis",tabName="Statistics analysis",icon=icon("pencil-ruler"),startExpanded=TRUE,
                 menuSubItem("Calendar",tabName="Calendar",icon=icon("calendar")),
                 menuSubItem("Ranking",tabName="Ranking",icon=icon("table")),
                 menuSubItem("Summary",tabName="Summary", icon=icon("chart-line"))),
        menuItem("About",tabName="about",icon=icon("sign-out"))
    )),
    dashboardBody(fill = FALSE,tabItems(
        #-------------------tab1 Home
        tabItem(tabName = "HOME",
                fluidRow(
                    valueBoxOutput("total_case"),
                    valueBoxOutput("total_recovered"),
                    valueBoxOutput("total_death")),
                fluidRow(box(width =  12, title = "US COVID-19 Cases by Day",
                             plotlyOutput("total_by_date"))),
                fluidRow(box(width =  12, title = "The Mortality_rate and the Recovery_rate by Day",
                             plotlyOutput("rate_by_date"))
                )),
        
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
        
        #-------------------tab4 Statstics analysis
        ##sub1--------------------------------------
        tabItem(tabName = "Calendar",
                fluidPage(
                    fluidRow(
                        (tabBox(
                            width=12,
                            title = "Calendar Plot",
                            tabPanel("Confirmed", plotOutput("cases_cald")),
                            tabPanel("Recovered", plotOutput("recovered_cald")),
                            tabPanel("Deaths",plotOutput("death_cald")),
                            tabPanel("New case",plotOutput("newcase_cald"))
                        )))
                )
        ),
        ##sub3------------------------------------------------
        tabItem(tabName = "Summary",
                fluidPage(
                    fluidRow(column(12,
                                    h4("In this part, we made the barchart of overall Confirmed cases / Recovered cases / Deaths over time/ Hospitalization_rate."),
                                    tags$div(tags$ul(
                                        tags$li(h4("The first barchart demonstrates overall Confirmed cases.")),
                                        tags$li(h4("The second barchart demonstrates Recovered cases.")),
                                        tags$li(h4("The third barchart demonstrates Deaths cases.")),
                                        tags$li(h4("The forth barchart demonstrates Hospitalization_rate ")))
                                    )),
                             fluidRow(column(width =  12, title = "Overall Confirmed cases",
                                             plotOutput("confirmed"))),
                             fluidRow(column(width =  12, title = "Recovered cases",
                                             plotOutput("recover_plt"))),
                             fluidRow(column(width =  12, title = "Deaths cases",
                                             plotOutput("deaths_plt"))),
                             fluidRow(column(width =  12, title = "Hospitalization_rate",
                                             plotOutput("Hospitalization_rate")))
                             
                    ))),
        ##sub2------------------------------------------------
        tabItem(tabName = "Ranking",
                fluidPage(
                    fluidRow(
                        (tabBox(
                            width=12,
                            title = "Top 10 State Analysis",
                            tabPanel("Top 10 Confirmed", plotlyOutput("top_10_confirmed")),
                            tabPanel("Top 10 Recovered", plotlyOutput("top_10_recovered")),
                            tabPanel("Top 10 Deaths",plotlyOutput("top_10_deaths"))
                        )))
                )),
        #-------------------tab5 About
        tabItem(tabName = "about",
                fluidPage(
                    mainPanel( width=12,
                               img(src="covid1.jpeg", width = "100%", height = "100%"),
                               
                               h1(strong("What you'll find from the web"),align = "center"),
                               column(12,
                                      tags$ul(
                                          tags$li(h4("In this project, we designed a shiny app with information about covid-19 in US." )), 
                                          tags$li(h4("By covid 19 US shiny app, you can easily find the information about the US cases spread map,state to state comparison,daily update of the cases,etc."))
                                      )
                               ),
                               br(),
                               h1(strong("About the Data"),align = "center"),
                               column(12,
                                      h4(" We used the date data from JHU.This dataset contains daily updated data of confirmed cases, recovered cases,deaths cases,test,hospitaliaztion information.
                         The data is up-to-date from 2020-04-12. We just keep 50 states and District of Columbia data for further exploration."),
                                      hr(),
                                      img(src="data.png", width = "100%", height = "30%",align = "center")),
                               br(),
                               column(12,
                                      h1(strong("About the team"),align = "center"),
                                      h4("The covid-19 US Spread App is creadted by
                           Citina Liang; Henan Xu; Xiangning Han." ,align = "center"),
                                      br(),br()
                               )),
                ),
                
        )
        
    ))
)
