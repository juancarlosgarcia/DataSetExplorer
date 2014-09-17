
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Data Set Explorer"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("datasetSelect", label = "Data Set:",
                  choices= c("iris", "mtcars", "diamond"),
                  selected="iris"
                  )
    ),

    # Show a plot of the generated distribution
    mainPanel(      
      tabsetPanel(
        tabPanel(textOutput("myDataset"), dataTableOutput("myTable")),
        tabPanel("Schema", dataTableOutput("myTableSchema"))
                 )
      )
    )
  )
)
