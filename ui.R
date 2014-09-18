
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Data Set Explorer"),

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
                 ),
      verbatimTextOutput("textTest")
      
      )
    )
  )
)
