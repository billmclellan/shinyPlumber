#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(ggplot2)
#library(glue)
library(shiny)
library(ggraph)
library(igraph)
library(tidygraph)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Graph Demo"),
    
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
            plotOutput("graphBind"),
            br(),
            plotOutput("graphJoin")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    gr1 <- reactive(
        create_notable('bull') %>% 
            mutate(name = letters[1:5])
    )
    gr2 <- reactive(
        create_ring(input$nodes) %>% 
            mutate(name = letters[c(1, 6:(input$nodes + 4))])
    )
    
    # Plot
    output$graphBind <- renderPlot(gr1() %>% bind_graphs(gr2()) %>% 
                                       ggraph(layout = 'kk') + 
                                       geom_edge_link() + 
                                       geom_node_point(size = 8, colour = 'steelblue') +
                                       geom_node_text(aes(label = name), colour = 'white', vjust = 0.4) + 
                                       ggtitle('Binding graphs') + 
                                       theme_graph()
    )
    
    output$graphJoin <- renderPlot(gr1() %>% graph_join(gr2()) %>% 
                                      ggraph(layout = 'kk') + 
                                      geom_edge_link() + 
                                      geom_node_point(size = 8, colour = 'steelblue') +
                                      geom_node_text(aes(label = name), colour = 'white', vjust = 0.4) + 
                                      ggtitle('Joining graphs') + 
                                      theme_graph()
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
