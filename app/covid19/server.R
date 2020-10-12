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
    df_plt2 <- reactive({
        df_plt %>% 
            filter(Province_State == input$state1 | 
                       Province_State == input$state2 | 
                       Province_State == 'Average')
    })
    
    output$death_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(aes(Last_Update, total_deaths, col=Province_State))+
            labs(title = 'Deaths Cases over time',
                 x='',
                 y='')+
            scale_fill_manual(values=cbPalette)+
            theme_minimal()
    })
    
    output$active_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, total_active, col=Province_State))+
            labs(title = 'Active Cases over time',
                 x='',
                 y='')+
            scale_fill_manual(values=cbPalette)+
            theme_minimal()
    })
    
    output$confirmed_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, total_confirmed, col=Province_State))+
            labs(title = 'Confirmed Cases over time',
                 x='',
                 y='')+
            scale_fill_manual(values=cbPalette)+
            theme_minimal()
    })
    
    output$recovered_plt <- renderPlotly({
        ggplot(df_plt2())+
            geom_line(mapping = aes(Last_Update, total_recovered, col=Province_State))+
            labs(title = 'Recovered Cases over time',
                 x='',
                 y='')+
            scale_fill_manual(values=cbPalette)+
            theme_minimal()
    })
    #-------------------tab4 Data Source
    
    
})

