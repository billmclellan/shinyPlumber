## install necessary packages

# first shiny app
install.packages("tidyverse", dependencies= TRUE)
#install.packages("glue", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)
install.packages("shiny", dependencies = TRUE)
install.packages("ggraph", dependencies = TRUE)
install.packages("igraph", dependencies = TRUE)
install.packages("tidygraph", dependencies = TRUE)

# plumber api
install.packages("plumber", dependencies = TRUE)

# deploy to azure kubernetes
install.packages("AzureRMR", dependencies = TRUE)
install.packages("AzureContainers", dependencies = TRUE)

# additional for final shiny app
install.packages("httr", dependencies = TRUE)
install.packages("png", dependencies = TRUE)
