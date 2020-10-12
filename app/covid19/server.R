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
    input$state1
    
    df_plt <- df_clean %>% 
        group_by(Province_State, Last_Update) %>% 
        summarise(total_deaths=sum(Deaths),
                  total_active=sum(Active),
                  total_confirmed=sum(Confirmed),
                  total_recovered=sum(Recovered)) %>% 
        filter(Province_State == state1() | Province_State == state2()
        ) 
    

    death <- ggplot(df_plt)+
        geom_line(mapping = aes(Last_Update, total_deaths))+
        #geom_line(mapping = aes(Last_Update, total_active), col=cbPalette[2])+
        #geom_line(mapping = aes(Last_Update, total_confirmed), col=cbPalette[3])+
        labs(title = paste0('Number of Deaths in ',' over time'),
             x='',
             y='')+
        #scale_fill_manual(values=cbPalette)+
        theme_minimal()

    output$death_plt <- renderPlotly({
        ggplotly(death)
    })
    #-------------------tab4 Data Source
    

})








