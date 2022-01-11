library(shiny)
library(wordcloud2)
library(tm)
library(colourpicker)
library("colorspace") 
library("shinydashboard")
library(shinyBS)
library(shinyalert)
library(dplyr)
library(tidyverse)


sentiment_pal <- c("black", "#E00008", "#858B8E", "#62A8E5", "#4000FF", "#1D2951")
pal <- c("black", "#E00008", "#858B8E", "white")

#bootstrapPage(

ui <- fluidPage(
  h1("Word Cloud"),
  h4(tags$a(href = "https://www.linkedin.com/in/ufuk-cem-birbiri-84881b213/", "Ufuk Cem Birbiri")),
  # Create a container for tab panels
  tabsetPanel(
    # Create a "Word cloud" tab
    tabPanel(
      title = "Word cloud",
      sidebarLayout(
        sidebarPanel(
          
          # Add the selector for GENRE
          selectInput(inputId = "genres",label = "Choose a genre",
            choices = c("Pop","Reggae","Metal","Hip-Hop","Blues","Dance_Music",
                        "Electronic","Poetry","Jazz","Rock","Country","Funk",
                        "House","Religious","Celtic","Theatre",
                        "Rap","Folk","Soul","Punk","New_Wave","Psychedelic",
                        "Christmas","Trance","Techno","Latin","Contemporary",
                        "Grunge","Classical_Music","Hardcore","Harmony" ,
                        "Acoustic","Comedy_Songs","Instrumental", "Not_Specified"),
            multiple = FALSE,selected = "Pop"
          ),
          uiOutput("slider_years"),
          checkboxInput("year_zero", "Only show songs that publication year is not specified in dataset?", FALSE),
          
          checkboxInput("remove_stopwords", "Remove stopwords words?", FALSE),
          checkboxInput("remove_words", "Remove specific words? (one per line and max 10 words)", FALSE),
          conditionalPanel(
            condition = "input.remove_words == 1",
            textAreaInput("words_to_remove1", "1.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove1.length > 0",
            textAreaInput("words_to_remove2", "2.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove2.length > 0",
            textAreaInput("words_to_remove3", "3.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove3.length > 0",
            textAreaInput("words_to_remove4", "4.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove4.length > 0",
            textAreaInput("words_to_remove5", "5.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove5.length > 0",
            textAreaInput("words_to_remove6", "6.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove6.length > 0",
            textAreaInput("words_to_remove7", "7.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove7.length > 0",
            textAreaInput("words_to_remove8", "8.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove8.length > 0",
            textAreaInput("words_to_remove9", "9.", rows = 1)),
          conditionalPanel(
            condition = "input.remove_words == 1 && input.words_to_remove9.length > 0",
            textAreaInput("words_to_remove10", "10.", rows = 1)),
          
          numericInput("num", "Number of words (minimum 3)",
                       value = 100, min = 3
          ),
          hr(),h4('Visualization Options:'),
          radioButtons(
            inputId = "style",
            label = "Recommended Styles:",
            choices = c("Default" = "Default","Jungle" = "Jungle","Barbie" = "Barbie","Dark theme" = "dark","Sunset" = "Sunset"),
            selected= "dark"),
          # Shape of the word cloud
          selectInput(
            inputId = "shape",label = "Choose Shape of the Word Cloud",
            choices = c("circle", "cardioid","diamond","triangle-forward","triangle","pentagon","star"),
            multiple = FALSE,selected = "circle"),
          hr(),
          sliderInput(inputId = "wordcloud_size", label= "Size of the Word Cloud", min = 1, max = 2.5,
                      value = 1.2,step = 0.1),
          hr(),
          HTML('<p>Report a  <a href="https://github.com/CemBirbiri">bug or view the code</a>.')
        ),
        mainPanel(
          wordcloud2Output(outputId = "wordcloud_ouputid",width = "100%", height = "600px"),
          br(),
          verbatimTextOutput(outputId = "nrows_filtered_data_by_years"),
          br()
        )
      )
    ),
    tabPanel(
         title = "What is Word-Cloud?",
          br(),
          h2("WORD CLOUD"),
          "Word clouds are also known as text clouds or tag clouds. They shows the frequency of the words in a textual data
          (for example a speech, tweet, email, or database). The bigger the word the bigger the frequency.

          A word cloud is a collection of words that appears in various sizes. Typically, a word cloud will ignore the most common words in the language. 
          These words are called stopwords.",
          h4("What are stopwords?"),
          
          " Stop words are basically a set of commonly used words in any language, not just in English.
          The reason why stop words are critical to many applications is that, if we remove the words that are very 
          commonly used in a given language, we can focus on the important words instead.",
          h5("Some examples of English stopwords:"),
          "i, me, my, myself, we, our, ours, ourselves, you, your, yours, they, what, which, who, whom, this, that, these,
          those, am, is, are, was, were, be, been, being, have, has, had, do, does, did, a, an, the, and, but, if, 
          or, because, as, until, s, t, can, will, just, don, should, now, ...",
          
          br(),
      
      
    ),
    # Create an "About this app" tab
    tabPanel(
      title = "About this app",
      br(),
      tags$a(href = "https://github.com/CemBirbiri", "Ufuk Cem Birbiri"),
      " is a first-year master student in Data Science & Artificial Intelligence MSc
      at Université Côte d'Azur, Nice, France.",
      br(),
      br(),
      "This app is the semester project of Data Visualization course (2021-Fall) given by ",
      tags$a(href = "https://www.i3s.unice.fr/~winckler/", "Marco Winckler"), "and",
      tags$a(href = "https://www.linkedin.com/in/aline-menin/?locale=en_US", "Aline Menin."),
      br(),
      br(),
      "The WASABI dataset is used to create word clouds. Here is the some useful links for the Wasabi dataset:",
      br(),
      "1. ",tags$a(href = "https://github.com/micbuffa/WasabiDataset", "Description of the DATASET WASABI"),
      br(),
      "2. ",tags$a(href = "https://wasabi.i3s.unice.fr/apidoc/", "Description of the API WASABI"),
      br(),
      "3. ",tags$a(href = "https://drive.google.com/file/d/1MbMgIB4D2fy-LLn_PAg22pdW_aIyjWfb/view?usp=sharing", "JSON file"),
      br(),
      br(),
      "Word clouds are built up for each genre using wasabi song lyrics. First, songs are grouped by their genre. Some genres are combined with others 
      according to their family relationships and origins. For example, samba, bachata and salsa are grouped under the Latin music. In addition the Skiffle music genre
      is originated from folk music so it is grouped by folk music genre.
      Then song lyrics summaries are used for creating word clouds. In slidebar panel, publication year of the songs can be chosen
      Word cloud shows the most frequent words between the given the range of publication years. 
      There are some songs that the publication date is not given in the dataset. 
      So,if the user selects the checkbox button of 'Only shows songs that publication date is not specified', the word cloud
      shows only the songs that do not have publication date and slide bar of the publication years does not work.",
      br(),
      "Also, there is an 
      option for removing stopwords as well as removing specific words from word cloud. Users are able to remove at most
      10 specific words. Finally, users can choose the number of words appear in word cloud. Minimum word count is 3.",
      br(),
      br(),
      "When you hold the mouse over the words in the word cloud, you can see how many times that word 
      is used in the lower left corner of the rectangle.",
      br(),
      br(),
      "In the below part of slidebar panel, there are some visualization options. Users can choose the shape and size of the
      word cloud. 5 different themes are presented such as Default option that is the default colors of wordcloud2 function
      in the worlcloud2 Shiny library, Jungle, Barbie, Dark theme and Sunset."
    )
    
  )
)

server <- function(input, output,session) {

  #World cloud render function without troubles
  wordcloud2a <- function(data, size = 1, minSize = 0, gridSize = 0, fontFamily = "Segoe UI", 
                           fontWeight = "bold", color = "random-dark", backgroundColor = "white", 
                           minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE, 
                           rotateRatio = 0.4, shape = "circle", ellipticity = 0.65, 
                           widgetsize = NULL, figPath = NULL, hoverFunction = NULL){
    if ("table" %in% class(data)) {
      dataOut = data.frame(name = names(data), freq = as.vector(data))}
    else {
      data = as.data.frame(data)
      dataOut = data[, 1:2]
      names(dataOut) = c("name", "freq")
    }
    if (!is.null(figPath)) {
      if (!file.exists(figPath)) {
        stop("cannot find fig in the figPath")}
      spPath = strsplit(figPath, "\\.")[[1]]
      len = length(spPath)
      figClass = spPath[len]
      if (!figClass %in% c("jpeg", "jpg", "png", "bmp", "gif")) {
        stop("file should be a jpeg, jpg, png, bmp or gif file!")}
      base64 = base64enc::base64encode(figPath)
      base64 = paste0("data:image/", figClass, ";base64,", base64)}
    else {base64 = NULL}
    weightFactor = size * 180/max(dataOut$freq)
    settings <- list(word = dataOut$name, freq = dataOut$freq, 
                     fontFamily = fontFamily, fontWeight = fontWeight, color = color, 
                     minSize = minSize, weightFactor = weightFactor, backgroundColor = backgroundColor, 
                     gridSize = gridSize, minRotation = minRotation, maxRotation = maxRotation, 
                     shuffle = shuffle, rotateRatio = rotateRatio, shape = shape, 
                     ellipticity = ellipticity, figBase64 = base64, hover = htmlwidgets::JS(hoverFunction))
    chart = htmlwidgets::createWidget("wordcloud2", settings, 
                                      width = widgetsize[1], height = widgetsize[2], sizingPolicy = htmlwidgets::sizingPolicy(viewer.padding = 0, 
                                                                                                                              browser.padding = 0, browser.fill = TRUE))
    chart
}

  #Loading the csv files for genres.Ex: pop.csv
  data_source <- reactive({
    path <- paste("GENRES/",tolower(input$genres),".csv",sep = "")
    data <- read.csv(path,stringsAsFactors = FALSE)
    return(data)})
  
  
  #Create world cloud with "worldcloud2a" function
  create_wordcloud <- function(data, num_words = 100, background , size, style, shape) {
    data <- data[, 2]
    # If text is provided, convert it to a dataframe of word frequencies
    if (is.character(data)) {
      corpus <- Corpus(VectorSource(data))
      corpus <- tm_map(corpus, tolower)
      #corpus <- tm_map(corpus, removePunctuation)
      corpus <- tm_map(corpus, removeNumbers)
      if(input$remove_stopwords){
        corpus <- tm_map(corpus, removeWords, stopwords(tolower("English")))}
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove1))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove2))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove3))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove4))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove5))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove6))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove7))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove8))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove9))
      corpus <- tm_map(corpus, removeWords, c(input$words_to_remove10))
      tdm <- as.matrix(TermDocumentMatrix(corpus))
      data <- sort(rowSums(tdm), decreasing = TRUE)
      data <- data.frame(word = names(data), freq = as.numeric(data))
    }
    # Make sure a proper num_words is provided
    if (!is.numeric(num_words) || num_words < 3) {
      num_words <- 3}
    # Grab the top n most common words
    data <- head(data, n = num_words)
    if (nrow(data) == 0) {
      return(NULL)}
    if(style=="dark"){
      wordcloud2a(data, size = size, shape=shape, 
                 color=rep_len( c("ghostwhite","#E00008", "#858B8E"), nrow(data)),backgroundColor = "black")}
    else if(style=="Barbie"){
      wordcloud2a(data, size = size, shape=shape, 
                 color=rep_len( c("purple","skyblue","navy","hotpink","red"), nrow(data)),backgroundColor = "pink")    }
    else if(style=="Sunset"){
      wordcloud2a(data, size = size, shape=shape, 
                 color=rep_len( c("#E43414","yellow","red","black"), nrow(data)),backgroundColor = "darkorange")    }
    else if(style=="Jungle"){
      wordcloud2a(data, size = size, shape=shape, 
                 color=rep_len( c("olivedrab","white","seagreen","yellow","green"), nrow(data)),backgroundColor = "#362204")    }
    else if(style=="Default"){
      wordcloud2a(data, size = size, shape=shape )}
  }
  
  #Render world cloud
  output$wordcloud_ouputid <- renderWordcloud2({
    create_wordcloud(data_filtered_by_years(),
                     num_words = input$num,
                     background = input$col,
                     size = input$wordcloud_size,
                     style = input$style,
                     shape= input$shape)
  })

  #Rendering slider input for the given years by user
  output$slider_years <- renderUI({
    data <- data_source()
    x <- data %>% filter(year != 0 ) %>% filter(year==min(year))
    minn <- x[, 1]
    minn <- unique(minn)
    x2 <- data %>% filter(year != 0 ) %>% filter(year==max(year))
    maxx <- x2[, 1]
    maxx <- unique(maxx)
    sliderInput("inslider", label = "Select the publication years", min = minn, max = maxx,value = c(minn,maxx),step=10)})
  
#-----------------------------
  #Filtering the data by inputted years by user.
  data_filtered_by_years <- reactive({
    filteredData <- data_source()
    #There are some songs that the publication date is not given in the dataset. 
    #So,if the user selects the checkbox button of "Only shows songs that publication date is not specified", the word cloud
    #shows only the songs that do not have publication date.
    if(input$year_zero ){
      filteredData <- filteredData %>% filter(year == 0) 
    }
    else{
      if(!is.null(input$inslider)){
        filteredData <- filteredData %>% filter(year >= input$inslider[1]) %>%filter(year <= input$inslider[2])}
    }
    return(filteredData)
  })
  
  #Number of songs between the years YEAR1 and YEAR2 is NROWS
  output$nrows_filtered_data_by_years <- renderPrint({
    filteredData <- data_filtered_by_years()
    print(paste("Number of songs between the years", input$inslider[1], "and",input$inslider[2],"is",nrow(filteredData) ))
  }) 
  

}

shinyApp(ui = ui, server = server)
