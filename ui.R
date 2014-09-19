
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(navbarPage("Quick Data Explorer",
  tabPanel("Data Exploration",
    fluidRow(
      column(4,
        wellPanel (
        selectInput("datasetSelect", label = "Data Set:",
                    choices= c("iris", "mtcars", "diamond"),
                    selected="iris"
                    )
        ),
  
        wellPanel (
          uiOutput("colsDropDown") 
        ),
        wellPanel (
          uiOutput("typesDropDown") 
        )
      ),
      
      
      column (8,      
        tabsetPanel(
          tabPanel(textOutput("myDataset"), dataTableOutput("myTable")),
          tabPanel("Schema", dataTableOutput("myTableSchema"))
                   )
        )
      )
    ),
    tabPanel ("Cluster Exploration",
      fluidRow(
        column(4,
         wellPanel (
           uiOutput("colsXDropDown")
         ),
         wellPanel (
           uiOutput("colsYDropDown")
         )
        )
      )
    ),
    tabPanel ("Plot Exploration",
        verbatimTextOutput("textTest2")
    )
  )
)
