rm(list = ls())
setwd("~/Marlize/2021/Frankryk/Klasse/Data Visualisation/Bubblemap")

library(shiny)
library(highcharter)
library(dplyr)
#library(shinyWidgets)

bm_data <- read.csv('../Data/data_clean_for_viz.csv')

bm_data$publicationDate <- as.integer(as.character(bm_data$publicationDate))

wmap <- hcmap(showInLegend = FALSE)

ui <- fluidPage(
    
    titlePanel("Bubble Map"), # Application title
    sidebarLayout(
        sidebarPanel(     
            
            sliderInput('mag','Show countries with more albums than', min = 0, max = 100, step = 1, value = 0),
            
            sliderInput(inputId = "period", label = "Years to display", min = 1594, max = 2020,
                                          value = c(1594,2020)),
            
            radioButtons("bubble", "Bubbles indicate",
                choices = c('Albums released'= 'albumCount','Awards received' = 'total_awards'),
                selected = "albumCount"),
            
            checkboxInput('UnknownVals', "Show unknown data", value = FALSE),
            
            #sliderInput('bublesize','Adjust bubble Size', min = 2, max = 100, step = 1, value = 15)      
        ),
        
        # Display a Map Bubble
        mainPanel(
            highchartOutput('eqmap',height = "550px"),
            verbatimTextOutput("Unknowns"),
            
        )
    )
)

# Aline: legend, sliders at top, map in middle, jenks breaks
#jenks breaks: 
# library(BAMMtools)
#getJenksBreaks(new_clean$albumCount, 10)

# Self: Incorporate years, and do something with unknown data

server <- function(input, output) {
    data <- reactive(bm_data %>% filter(albumCount >= input$mag) %>% filter(publicationDate >= input$period[1]) %>%
                         filter(publicationDate <= input$period[2]) %>% group_by(country, lat, lon, continent) %>% 
                         rename(z = input$bubble) %>% summarise(z = sum(z)))
        
    aw_alb <- reactive(ifelse(input$bubble == 'albumCount', 'Albums released: {point.z}', 'Awards received: {point.z}'))
    bubbles_size <- reactive(data()$z)
    #bubbles_size_max <- reactive(max(bubbles_size()))
        
    output$eqmap <-renderHighchart(
            
        wmap %>% 
            hc_add_series(data = subset(data(), continent == "Africa"), type = "mapbubble", minSize = "1%", maxSize = '15%', showInLegend = TRUE, color = "Red", name = "Africa") %>% #bubble size in perc %
            hc_add_series(data = subset(data(), continent == "Europe"), type = "mapbubble", minSize = "1%", maxSize = '15%', showInLegend = TRUE, color = "Blue", name = "Europe") %>%
            hc_add_series(data = subset(data(), continent == "Asia"), type = "mapbubble", minSize = "1%", maxSize = '15%', showInLegend = TRUE, color = "Orange", name = "Asia") %>%
            hc_add_series(data = subset(data(), continent == "Central America" | continent == "North America"), type = "mapbubble", minSize = "1%", maxSize = '15%', showInLegend = TRUE, color = "Teal", name = "North America") %>%
            hc_add_series(data = subset(data(), continent == "South America"), type = "mapbubble", minSize = "1%", maxSize = '15%', showInLegend = TRUE, color = "Purple", name = "South America") %>%
            hc_add_series(data = subset(data(), continent == "Australia"), type = "mapbubble", minSize = "1%", maxSize = '15%', showInLegend = TRUE, color = "Green", name = "Australia") %>%
                
            hc_legend(bubbleLegend = list(
                    enabled = TRUE,
                    borderColor = 'black',
                    borderWidth = 1,
                    color = 'white',
                    connectorColor = '#000000',
                    sizeBy = bubbles_size()),
                    align = "bottom", layout = "horizontal",
                    floating = TRUE ,valueDecimals = 0,
                    symbolHeight = 10, symbolWidth = 10, symbolRadius = 0) %>%
                
            hc_tooltip(useHTML = T,headerFormat='',pointFormat = paste('Location :{point.country}, ', aw_alb())) %>%
                
            hc_title(text = "Global Album Releases and Awards") %>%
            hc_subtitle(text = paste('Number of observations:', nrow(data()),sep = '')) %>%
            hc_mapNavigation(enabled = T)
        )
    
    output$Unknowns <- renderText({
        if (input$UnknownVals == TRUE){
            unknown_data <- data()[which(data()$country == "Unknown"), ]
            
            if (input$bubble == "albumCount") {
                unknown_stats <- sum(unknown_data[,5])
                album_or_award <- "albums released"
            } else {
                unknown_stats <- sum(unknown_data[,5])
                album_or_award <- "awards received"
            }
            
            info_text <- paste0("There are ", unknown_stats, " ", album_or_award, " in unknown countries.")
            info_text
        }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)