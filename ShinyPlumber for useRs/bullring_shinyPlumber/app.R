#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggraph)
library(igraph)
library(tidygraph)
library(httr)
library(png)

source("secrets.R")
# function(s)

url = 'http://104.211.11.94:8000' 
curlBullRing <- function(nodes = 3) {
    nodes <- as.character(nodes)
    response <- httr::GET(paste(url, "bullring", sep = "/"), query = list(nodes = nodes))
    graphList <- httr::content(response, simplifyVector=TRUE)
    nodeTibble <- as_tibble(cbind(id = 1:length(graphList$nodes$name), name = graphList$nodes$name))
    edgeTibble <- as_tibble(cbind(graphList$edges$from, graphList$edges$to))
    bullring <- tbl_graph(nodes = nodeTibble, edges = edgeTibble, directed = FALSE)
}

plotBullRing <- function(bullring = bullring) {
    bullRingPlot <- bullring %>% ggraph(layout = 'kk') + 
        geom_edge_link() + 
        geom_node_point(size = 8, colour = 'steelblue') +
        geom_node_text(aes(label = name), colour = 'white', vjust = 0.4) + 
        ggtitle('Joining Notable Graphs Bull & Ring on Name') + 
        theme_graph(base_family = 'Helvetica')
    print(bullRingPlot)
}

curlPlot <- function() {
    httr::GET(paste(url, "plot", sep = "/")) %>% content()
}

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Shiny Plumber"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("nodes",
                        "Number of nodes:",
                        min = 3,
                        max = 22,
                        value = 5)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("graphPlot"),
            br(),
            plotOutput("graphImage")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    bullring <- reactive(curlBullRing(input$nodes))
    
    # Plot
    output$graphPlot <- renderPlot(plotBullRing(bullring()))
    
    output$graphImage <- renderImage({
        validate(need(bullring(), label = 'bullring'))
        # A temp file to save the output.
        # This file will be removed later by renderImage
        outfile <- tempfile(fileext = '.png')
        
        # Generate the PNG
        curlPlot() %>%  png::writePNG(outfile)
        
        # Return a list containing the filename
        list(src = outfile,
             contentType = 'image/png',
             #width = 400,
             #height = 300,
             alt = "plumber image")
    }, deleteFile = TRUE)
}

# Run the application 
shinyApp(ui = ui, server = server)
