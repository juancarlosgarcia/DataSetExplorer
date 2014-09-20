
# UI - Quick Data Explorer
# Created by Juan Carlos Garcia
# September,9 2014.


library(shiny)

shinyUI(navbarPage("Quick Data Explorer",
  tabPanel("Data Exploration",
    fluidRow(
      column(4,
        wellPanel (
        selectInput("datasetSelect", label = "Data Set:",
                    choices= c("iris", "mtcars","diamond", "diamonds", "airquality"),
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
    tabPanel ("Plot Exploration",
            fluidRow(
              column(4,
                     wellPanel (
                       uiOutput("plotXDropDown"),
                       uiOutput("plotYDropDown"),
                       uiOutput("plotColorDropDown"),
                       uiOutput("plotFacetRowDropDown"),
                       uiOutput("plotFacetColDropDown")
                     )
              ),
              column(8,
                     wellPanel (
                       plotOutput("plotExplorer")
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
         ),
         wellPanel (
            numericInput('clusters', 'Cluster count', 3,min = 1, max = 9)
         )
        ),
        column(8,
               wellPanel (
                 plotOutput("plotCluster") 
               )               
        )
      )
    )
  )
)
