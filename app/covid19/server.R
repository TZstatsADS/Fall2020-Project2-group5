#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#source("global.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    #-------------------tab1 Home
    

    #-------------------tab2 Map
    date_data = reactive({
        data %>% filter(Last_Update == input$DateInput)
    })
    
    Indicator_data = reactive({
        date_data() %>% 
            select(Province_State, Last_Update, Value = input$IndicatortInput) %>%
            mutate(Province_State = tolower(Province_State))
    })
    
    output$drawmap <- renderLeaflet(draw_map(Indicator_data(), input$IndicatortInput))
    

    
    #-------------------tab3 Search Panel
    # switch to %
    prect_or_freq <- reactive({
        ifelse(input$prect, 'prect_deaths', 'total_deaths')
        #input$prect
    })

    # deaths
    df_plt2 <- reactive({
        df_plt %>% 
            filter(Province_State == input$state1 | 
                       Province_State == input$state2 | 
                       Province_State == 'Average')
    })

    df_plt3 <- reactive({
        df_plt %>%
            filter(Province_State == input$state1 |
                       Province_State == input$state2 |
                       Province_State == 'Average') %>%
            select(Last_Update, Province_State, y = prect_or_freq())
    })

    output$death_plt <- renderPlotly({
        #df_plt2()$y <- ifelse(prect_or_freq(), df_plt2()['prect_deaths'], df_plt2()['total_deaths'])
        ggplot(df_plt3())+
            geom_line(aes(Last_Update, y, col=Province_State))+
            labs(title = 'Deaths Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # active
    output$active_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, total_active, col=Province_State))+
            labs(title = 'Active Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # confirmed
    output$confirmed_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, total_confirmed, col=Province_State))+
            labs(title = 'Confirmed Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # recovered
    output$recovered_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, total_recovered, col=Province_State))+
            labs(title = 'Recovered Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # info box part
    output$deaths_val <- renderValueBox({
        valueBox(df_plt2()$total_deaths[df_plt2()$Last_Update==max(df_plt2()$Last_Update)&df_plt2()$Province_State==input$state1],
                 'DEATHS',
                 icon = icon("skull-crossbones"), color = 'red')
    })
    output$confirmed_val <- renderValueBox({
        valueBox(df_plt2()$total_confirmed[df_plt2()$Last_Update==max(df_plt2()$Last_Update)&df_plt2()$Province_State==input$state1],
                 'CONFIRMED',
                 icon = icon("viruses"), color = 'orange')
    })
    output$active_val <- renderValueBox({
        valueBox(df_plt2()$total_active[df_plt2()$Last_Update==max(df_plt2()$Last_Update)&df_plt2()$Province_State==input$state1],
                 'ACTIVE',
                 icon = icon("head-side-mask"), color = 'yellow')
    })
    output$recovered_val <- renderValueBox({
        valueBox(df_plt2()$total_recovered[df_plt2()$Last_Update==max(df_plt2()$Last_Update)&df_plt2()$Province_State==input$state1],
                 'RECOVERED',
                 icon = icon("heart"), color = 'green')
    })
    output$peopletested_val <- renderValueBox({
        valueBox(df_plt2()$People_Tested[df_plt2()$Last_Update==max(df_plt2()$Last_Update)&df_plt2()$Province_State==input$state1],
                 'PEOPLE TESTED',
                 icon = icon("vial"), color = 'blue')
    })
    output$incidentrate_val <- renderValueBox({
        valueBox(df_plt2()$Incident_Rate[df_plt2()$Last_Update==max(df_plt2()$Last_Update)&df_plt2()$Province_State==input$state1],
                 'INCIDENT RATE',
                 icon = icon("running"), color = 'aqua')
    })
    
    
    #-------------------tab4 Data Source
    
    
})
