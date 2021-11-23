rm(list = ls())
setwd("~/Marlize/2021/Frankryk/Klasse/Data Visualisation/Bubblemap")

library(shiny)
library(highcharter)
library(dplyr)

bm_data <- read.csv('../Data/data_clean_for_viz.csv')
wmap <- hcmap()

ui <- fluidPage(
    
    titlePanel("Bubble Map"), # Application title
    sidebarLayout(
        sidebarPanel(     
            
            sliderInput('mag','Show countries with more albums than', min = 0, max = 25, step = 1, value = 0),
            
            selectInput('bubble','Bubbles indicate',choices = c('Albums released'= 'albumCount','Awards received' = 'total_awards')),
            
            sliderInput('bublesize','Adjust bubble Size',min = 2,max = 10,step = 1,value = 6)      
        ),
        
        # Display a Map Bubble
        mainPanel(
            highchartOutput('eqmap',height = "500px")         
        )
    )
)

server <- function(input, output) {
    data <- reactive(bm_data %>% 
                         filter(albumCount >= input$mag) %>%
                         rename(z = input$bubble))
    
    output$eqmap <-renderHighchart(
        
        wmap %>% hc_legend(enabled = F) %>%
            
            hc_add_series(data = data(), type = "mapbubble", name = "", maxSize = paste0(input$bublesize,'%')) %>% #bubble size in perc %
            
            hc_tooltip(useHTML = T,headerFormat='',pointFormat = paste('Location :{point.country}, ',input$bubble,': {point.z}')) %>%
            
            hc_title(text = "Global Album Releases and Awards") %>%
            hc_subtitle(text = paste('Number of observations:', nrow(data()),sep = '')) %>%
            hc_mapNavigation(enabled = T)
    )
}

# Run the application 
shinyApp(ui = ui, server = server)