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
    # switch freq and %
    prect_or_freq <- reactive({
        #ifelse(input$prect, 'prect_deaths', 'total_deaths')
        input$prect
    })
    
    df_plt2 <- reactive({
        tmp <- 
            df_plt %>% 
            filter(Province_State == input$state1 | 
                       Province_State == input$state2 | 
                       Province_State == 'Average')
        if(prect_or_freq()){
            tmp$y_d <- tmp$prect_deaths
            tmp$y_a <- tmp$prect_active
            tmp$y_c <- tmp$prect_confirmed
            tmp$y_r <- tmp$prect_recovered
        }else{
            tmp$y_d = tmp$total_deaths
            tmp$y_a = tmp$total_active
            tmp$y_c = tmp$total_confirmed
            tmp$y_r = tmp$total_recovered
        }
        tmp
    })
    
    # deaths
    output$death_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(aes(Last_Update, y_d, col=Province_State))+
            labs(title = 'Deaths Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # active
    output$active_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, y_a, col=Province_State))+
            labs(title = 'Active Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # confirmed
    output$confirmed_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, y_c, col=Province_State))+
            labs(title = 'Confirmed Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # recovered
    output$recovered_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, y_r, col=Province_State))+
            labs(title = 'Recovered Cases Over Time',
                 x='',
                 y='',
                 col='States')+
            theme_minimal()
    })
    
    # incident rate
    output$incidentrate_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, Incident_Rate, col=Province_State))+
            labs(title = 'Incident Rate Over Time',
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
    
    #-------------------tab4 About
    #subtab calendar
    output$cases_cald<-renderPlot({
      plot(cases_calendar)
    })
    output$recovered_cald<-renderPlot({
      plot(recovered_calendar)
    })
    output$death_cald<-renderPlot({
      plot(death_calendar)
    })
    output$newcase_cald<-renderPlot({
      plot(new_cases_calendar)
    })
    
    #-------------------tab5 Statistics analysis
    #subtab summary
    output$comfirmed<-renderPlot({
      ggplot(corona,aes(x =Last_Update, y= Confirmed, fill = Confirmed)) +
        geom_bar(stat = "identity") +
        scale_fill_viridis(option = "D") +
        labs(fill = "Confirmed", x = "", y = "") +
        theme_dark() +
        theme(legend.title = element_text(face = "bold"))
    })
    output$recover_plt<-renderPlot({
      corona %>%
        ggplot(aes(x = Last_Update, y= Deaths, fill = Deaths)) +
        geom_bar(stat = "identity") +
        scale_fill_viridis(option = "C") +
        labs(fill = "Deaths", x = "", y = "") +
        theme_dark() +
        theme(legend.title = element_text(face = "bold"))
    })
    output$deaths_plt<-renderPlot({
      corona %>%
        ggplot(aes(x = Last_Update, y= Recovered, fill = Recovered)) +
        geom_bar(stat = "identity") +
        scale_fill_viridis(option = "A") +
        labs(fill = "Recovered", x = "", y = "") +
        theme_dark() +
        theme(legend.title = element_text(face = "bold"))
    })
    output$Hospitalization_rate<-renderPlot({
      corona %>%
        ggplot(aes(x = Last_Update, y= Hospitalization_Rate, fill = Hospitalization_Rate)) +
        geom_bar(stat = "identity") +
        scale_fill_viridis(option = "A") +
        labs(fill = "Hospitalization_Rate", x = "", y = "") +
        theme_dark() +
        theme(legend.title = element_text(face = "bold"))
    })
    #subtab ranking
    top_10_confirmed <- corona %>%
      select(Last_Update,Province_State, Confirmed) %>%
      group_by(Province_State)%>%
      summarise(Confirmed=sum(Confirmed),.groups = 'drop')%>%
      arrange(desc(Confirmed))
    output$top_10_confirmed<-renderPlotly({top_10_confirmed[1:10,] %>%
        ggplot(aes(x = reorder(`Province_State`,Confirmed), y = Confirmed )) +
        geom_bar(stat = "identity", fill  = "red", width = 0.8) +
        theme_economist() +
        scale_y_continuous(breaks = seq(0, 55000000, by = 5000000), labels = comma) +
        coord_flip() +
        labs(x = "", y = "", title = "Top 10 (the Most Confirmed Cases)") +
        theme(axis.text.x = element_text(angle = 60)) +
        theme(axis.title = element_text(size = 14, colour = "black"),
              axis.text.y = element_text(size = 11, face = "bold"))})
    
    top_10_recover <- corona %>%
      select(Last_Update,Province_State, Recovered) %>%
      group_by(Province_State)%>%
      summarise(Recovered=sum(Recovered),.groups = 'drop')%>%
      arrange(desc(Recovered))
    output$top_10_recovered<-renderPlotly({
      top_10_recover[1:10,] %>%
        ggplot(aes(x = reorder(`Province_State`,Recovered), y = Recovered )) +
        geom_bar(stat = "identity", fill  = "red", width = 0.8) +
        theme_economist() +
        scale_y_continuous(breaks = seq(0, 55000000, by = 5000000), labels = comma) +
        coord_flip() +
        labs(x = "", y = "", title = "Top 10 (the Most Recovered Cases)") +
        theme(axis.text.x = element_text(angle = 60)) +
        theme(axis.title = element_text(size = 14, colour = "black"),
              axis.text.y = element_text(size = 11, face = "bold"))})
    
    top_10_death <- corona %>%
      select(Last_Update,Province_State, Deaths) %>%
      group_by(Province_State)%>%
      summarise(Deaths=sum(Deaths),.groups = 'drop')%>%
      arrange(desc(Deaths))
    output$top_10_deaths<-renderPlotly({
      top_10_death[1:10,] %>%
        ggplot(aes(x = reorder(`Province_State`,Deaths), y = Deaths )) +
        geom_bar(stat = "identity", fill  = "red", width = 0.8) +
        theme_economist() +
        scale_y_continuous(breaks = seq(0, 5500000, by = 500000), labels = comma) +
        coord_flip() +
        labs(x = "", y = "", title = "Top 10 (the Most Deaths Cases)") +
        theme(axis.text.x = element_text(angle = 60)) +
        theme(axis.title = element_text(size = 14, colour = "black"),
              axis.text.y = element_text(size = 11, face = "bold"))})
    
    #-------------------tab1 home
    output$total_case <- renderValueBox({
      corona%>%
        summarise(total_case=sum(Confirmed))%>%
        .$total_case%>%
        valueBox(subtitle = "Total Case Confirmed",
                 icon = icon("disease"),
                 color = "red")
    })
    
    output$total_recovered <- renderValueBox({
      corona %>%
        summarise(total_recovered = sum(Recovered))%>%
        .$total_recovered %>%
        valueBox(subtitle = "Total Recovered Case",
                 icon = icon("smile-wink"),
                 color = "green")
    })
    
    output$total_death <- renderValueBox({
      corona %>%
        summarise(total_death = sum(Deaths))%>%
        .$total_death %>%
        valueBox(subtitle = "Total Dead Case",
                 icon = icon("user-alt-slash"),
                 color = "purple")
    })
    
    
})
