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
    
    #-------------------tab3 Search Panel
   
    state1 <- reactive(input$state1)
    state2 <- reactive(input$state2)
    
    df_plt <- df_clean %>% 
        group_by(Province_State, Last_Update) %>% 
        summarise(total_deaths=sum(Deaths),
                  total_active=sum(Active),
                  total_confirmed=sum(Confirmed),
                  total_recovered=sum(Recovered)) %>% 
        filter(Province_State == state1 | Province_State == state2)
    
    output$death_plt <- renderPlotly({
        ggplot(df_plt())+
            geom_line(aes(Last_Update, total_deaths, col=Province_State, lty=Province_State))+
            #geom_line(mapping = aes(Last_Update, total_active), col=cbPalette[2])+
            #geom_line(mapping = aes(Last_Update, total_confirmed), col=cbPalette[3])+
            labs(title = paste0('Number of Deaths in ', input$state1, ' vs ', input$state2,' over time'),
                 x='',
                 y=''
                 )+
            scale_fill_manual(values=cbPalette,
                              name='')+
            theme_minimal()
    })
    #-------------------tab4 Data Source
    

})








