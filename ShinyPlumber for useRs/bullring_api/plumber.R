#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(ggraph)
library(igraph)
library(tidygraph)

# function(s)
bullRing <- function(nodes = 3) {
  gr1 <- create_notable('bull') %>% 
    mutate(name = letters[1:5])
  gr2 <- create_ring(nodes) %>% 
    mutate(name = letters[c(1, 6:(nodes + 4))])
  bullring <<- gr1 %>% graph_join(gr2)
}

plotBullRing <- function() {
  bullRingPlot <- bullring %>% ggraph(layout = 'kk') + 
    geom_edge_link() + 
    geom_node_point(size = 8, colour = 'steelblue') +
    geom_node_text(aes(label = name), colour = 'white', vjust = 0.4) + 
    ggtitle('Joining Notable Graphs Bull & Ring on Name') + 
    theme_graph(base_family = 'Helvetica')
  print(bullRingPlot)
}

bullRing()
plotBullRing()

#* @apiTitle Plumber Example API

#* create bullring graph
#* @param nodes The number of nodes in the bull's ring
#* @get /bullring
function(nodes) {
  nodes <- as.numeric(nodes)  
  bullring <<- bullRing(nodes)
  bullring %>% lapply(as.list) 
}

#* Plot a bull ring
#* @png
#* @get /plot
function() {
  #plot(bullring)
  plotBullRing()
}

