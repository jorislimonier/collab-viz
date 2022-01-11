rm(list = ls())
# make sure that your working directory is suitable. It is assumed that the data is in the same forder as the app.
setwd("~/Marlize/2021/Frankryk/Klasse/Data Visualisation/Project/Marlize/Visualisation")

library(shiny)
library(highcharter)
library(dplyr)
library(shinythemes)

# read in the data to be used
bm_data <- read.csv('data_clean_for_viz.csv')

bm_data$publicationDate <- as.integer(as.character(bm_data$publicationDate))

# create the map data
wmap <- hcmap(showInLegend = FALSE)

# create the app user interface
ui <- fluidPage(
    
    theme = shinytheme("flatly"),
    
    titlePanel(h2("Bubble Map", h4("by Marlize de Villiers"))),
    
    tabsetPanel(
        tabPanel("Introduction", # this will be the first thing the user sees. It contains info about the app.
                 p("This is the visualisation created for the Data Visualisation module for the MSc Data Science and AI degree. 
                   It was created by Marlize de Villiers for the final evaluation of the module.
                   The data that was used for the visualisation comes from the WASABI dataset, and it was used to produce a 
                   bubble map of the number of music albums that were released in a given period all over the world, as well
                   as the number of awards that the albums received.
                   The objective of the visualisation is to see how the number of album releases and awards received differ
                   over time and from country to country.
                   It can be useful for up-and-coming artists that want to maximise their chances of having their album
                   released or receiving an award for their albums.
                   It is also interesting for people who want to see how the data changes over time."),
                 p("On the ", em("Visualisation tab"), "you will see two main panels.
                   The left panel contains controls that can be used to refine and choose what data should be displayed in
                   in the visualisation.
                   The right panel shows the interactive visualisation. You can zoom in and out using the '+' and '-' controls
                   in the upper left corner of the visualisation, or by using your mouse scroller. You can also navigate
                   around the map once you are zoomed in by clicking and dragging the map with your mouse.
                   You can click on the legend with the continents to show only certain continents' data.
                   You can also hover over the bubbles to see detailed information for each country."
                   ),
                 p(em("Some notes: The dataset contained a lot of missing information, that is why some countries have no data. 
                 You can choose to see the data that cannot be allocated to a country or a year by selecting 
                 the missing data checkbox. Lastly, the visualisation does take some time to update after selecting some 
                      of the controls."))
        ),
        
        tabPanel("Visualisation", # this tab will contain the visualisation
                 sidebarLayout(
                     sidebarPanel( h4(strong("Data Controls")),     
                         sliderInput('mag','Show countries with more albums released than', min = 0, max = 500, step = 1, 
                                     value = 0),
                         sliderInput(inputId = "period", label = "Years to display", min = 1594, max = 2020,
                                     value = c(1594,2020)),
                         radioButtons("bubble", "Bubbles indicate",
                                      choices = c('Albums released'= 'albumCount','Awards received' = 'total_awards', 
                                                  "Both" = 'b'), selected = "albumCount"),
                         checkboxInput('UnknownVals', "Show unknown data", value = FALSE)),
                     
                     mainPanel(
                         highchartOutput('eqmap',height = "550px"),
                         verbatimTextOutput("Unknowns"))
                 )
            )
        )
    )

server <- function(input, output) { # here we work with the data and selected controls to create the visualisation
    
    data <- reactive(bm_data %>% filter(albumCount >= input$mag) %>% filter(publicationDate >= input$period[1]) %>%
                         filter(publicationDate <= input$period[2]) %>% group_by(country, lat, lon, continent))
    
    observe(if (input$bubble == "albumCount") {
        data_1 <- reactive(data() %>% rename(z = input$bubble) %>% summarise(z = sum(z)) %>% filter(z >= 1))
        
        aw_alb <- reactive('Albums released: {point.z}')
        bubbles_size <- reactive(data_1()$z)
        
        output$eqmap <-renderHighchart(
            
            wmap %>% 
                hc_add_series(data = subset(data_1(), continent == "Africa"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#7C6A0A", name = "Africa",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}')) %>% #bubble size in perc %
                hc_add_series(data = subset(data_1(), continent == "Europe"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#E08D79", name = "Europe",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Asia"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#2D936C", name = "Asia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Central America" | continent == "North America"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#993955", name = "North America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "South America"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#EC9F05", name = "South America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Australia"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#C44900", name = "Australia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}')) %>%
                
                hc_legend(align = "left", layout = "vertical", verticalAlign = "bottom",
                          floating = TRUE ,valueDecimals = 0,
                          symbolHeight = 10, symbolWidth = 10, symbolRadius = 0,
                          
                          bubbleLegend = list(
                          enabled = TRUE,
                          borderColor = 'black',
                          borderWidth = 1,
                          color = 'white',
                          connectorColor = '#000000',
                          sizeBy = bubbles_size())) %>%
                
                hc_tooltip() %>%
                
                hc_title(text = "Global Album Releases and Awards") %>%
                hc_mapNavigation(enabled = T)
        )
    }) 
    
    observe(if (input$bubble == "total_awards") {
        data_1 <- reactive(data() %>% rename(z = total_awards) %>% summarise(z = sum(z)) %>% filter(z >= 1))
        
        aw_alb <- reactive('Awards received: {point.z}')
        bubbles_size <- reactive(data_1()$z)
        
        output$eqmap <-renderHighchart(
            
            wmap %>% 
                hc_add_series(data = subset(data_1(), continent == "Africa"), type = "mapbubble", minSize = "1%", maxSize = '6%', showInLegend = TRUE, color = "#7C6A0A", name = "Africa",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>% #bubble size in perc %
                hc_add_series(data = subset(data_1(), continent == "Europe"), type = "mapbubble", minSize = "1%", maxSize = '6%', showInLegend = TRUE, color = "#E08D79", name = "Europe",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Asia"), type = "mapbubble", minSize = "1%", maxSize = '6%', showInLegend = TRUE, color = "#2D936C", name = "Asia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Central America" | continent == "North America"), type = "mapbubble", minSize = "1%", maxSize = '6%', showInLegend = TRUE, color = "#993955", name = "North America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "South America"), type = "mapbubble", minSize = "1%", maxSize = '6%', showInLegend = TRUE, color = "#EC9F05", name = "South America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Australia"), type = "mapbubble", minSize = "1%", maxSize = '6%', showInLegend = TRUE, color = "#C44900", name = "Australia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                
                
                hc_legend(align = "left", layout = "vertical", verticalAlign = "bottom",
                          floating = TRUE ,valueDecimals = 0,
                          symbolHeight = 10, symbolWidth = 10, symbolRadius = 0,
                          
                          bubbleLegend = list(
                          enabled = TRUE,
                          borderColor = 'black',
                          borderWidth = 1,
                          color = 'white',
                          connectorColor = '#000000',
                          sizeBy = bubbles_size())) %>%
                
                hc_tooltip() %>%
                
                hc_title(text = "Global Album Releases and Awards") %>%
                hc_mapNavigation(enabled = T)
        )
    })
    
    observe(if (input$bubble == "b") {
        bm_data$b = 0
        data_1 <- reactive(data() %>% rename(z = albumCount, z1 = total_awards) %>% summarise(z = sum(z), z1 = sum(z1)))
        
        data_2 <- reactive(data() %>% rename(z = total_awards) %>% summarise(z = sum(z)) %>% filter(z >= 1))

        bubbles_size_alb <- reactive(data_2()$z)
        
        output$eqmap <-renderHighchart(
            
            wmap %>% 
                hc_add_series(data = subset(data_1(), continent == "Africa"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#7C6A0A", name = "Africa",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}, Awards received: {point.z1}')) %>% #bubble size in perc %
                hc_add_series(data = subset(data_1(), continent == "Europe"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#E08D79", name = "Europe",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}, Awards received: {point.z1}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Asia"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#2D936C", name = "Asia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}, Awards received: {point.z1}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Central America" | continent == "North America"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#993955", name = "North America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}, Awards received: {point.z1}')) %>%
                hc_add_series(data = subset(data_1(), continent == "South America"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#EC9F05", name = "South America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}, Awards received: {point.z1}')) %>%
                hc_add_series(data = subset(data_1(), continent == "Australia"), type = "mapbubble", minSize = "1.5%", maxSize = '15%', showInLegend = TRUE, color = "#C44900", name = "Australia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Albums released: {point.z}, Awards received: {point.z1}')) %>%
                
                hc_add_series(data = subset(data_2(), continent == "Africa"), type = "mapbubble", minSize = "1%", maxSize = '8%', showInLegend = FALSE, color = "#7C6A0A", name = "Africa",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>% #bubble size in perc %
                hc_add_series(data = subset(data_2(), continent == "Europe"), type = "mapbubble", minSize = "1%", maxSize = '8%', showInLegend = FALSE, color = "#E08D79", name = "Europe",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_2(), continent == "Asia"), type = "mapbubble", minSize = "1%", maxSize = '8%', showInLegend = FALSE, color = "#2D936C", name = "Asia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_2(), continent == "Central America" | continent == "North America"), type = "mapbubble", minSize = "1%", maxSize = '15%', showInLegend = FALSE, color = "#993955", name = "North America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_2(), continent == "South America"), type = "mapbubble", minSize = "1%", maxSize = '8%', showInLegend = FALSE, color = "#EC9F05", name = "South America",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                hc_add_series(data = subset(data_2(), continent == "Australia"), type = "mapbubble", minSize = "1%", maxSize = '8%', showInLegend = FALSE, color = "#C44900", name = "Australia",
                              tooltip = list(pointFormat = 'Location: {point.country}, Awards received: {point.z}')) %>%
                
                
                hc_legend(align = "left", layout = "vertical", verticalAlign = "bottom",
                          floating = TRUE ,valueDecimals = 0,
                          symbolHeight = 10, symbolWidth = 10, symbolRadius = 0,
                          
                          bubbleLegend = list(
                          enabled = TRUE,
                          borderColor = 'black',
                          borderWidth = 1,
                          color = 'white',
                          connectorColor = '#000000',
                          sizeBy = bubbles_size_alb())) %>%
                
                hc_tooltip() %>%
                
                hc_title(text = "Global Album Releases and Awards") %>%
                hc_mapNavigation(enabled = T)
        )
        
    })
            
    observe(if (input$UnknownVals == TRUE){
        
        unknown_data <- reactive(data()[which(data()$country == "Unknown"), ])
        unknown_data_dates <- reactive(bm_data[which(is.na(bm_data$publicationDate) == TRUE), ])
                    
        if (input$bubble == "albumCount") {
            unknown <- sum(unknown_data()[,5])
            unknown_dates <- sum(unknown_data_dates()[,5])
            info_text <- reactive(paste0("There are ", unknown, " albums released in unknown countries."))
            info_text_dates <- reactive(paste0("There are ", unknown_dates, " albums released in unknown years."))
            
        } else if (input$bubble == "total_awards") {
            unknown <- sum(unknown_data()[,4])
            unknown_dates <- sum(unknown_data_dates()[,4])
            info_text <- reactive(paste0("There are ", unknown, " awards received in unknown countries."))
            info_text_dates <- reactive(paste0("There are ", unknown_dates, " awards received in unknown years."))
            
        } else {
            unknown_alb <- sum(unknown_data()[,5])
            unknown_aw <- sum(unknown_data()[,4])
            unknown_dates_alb <- sum(unknown_data_dates()[,5])
            unknown_dates_aw <- sum(unknown_data_dates()[,4])
            info_text <- reactive(paste0("There are ", unknown_alb, " albums released and ", unknown_aw, " awards received in unknown countries."))
            info_text_dates <- reactive(paste0("There are ", unknown_dates_alb, " albums released and ", unknown_dates_aw, " awards received in unknown years."))
        }
                
        output$Unknowns <- renderText({
            paste(info_text(), info_text_dates(), sep="\n")
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
