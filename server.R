
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(UsingR)

shinyServer(function(input, output) {
  
  getDataset <- reactive({
    if (is.null(input$datasetSelect))
      return()
    
    data <- switch (input$datasetSelect, 
                    iris = iris,
                    mtcars = mtcars,
                    diamond = diamond)    
    data       
  })
  
  getDataTypes <- reactive({
    data = getDataset()
    cols <- colnames(data)
    n <-  length(cols)
    dfTypes <- data.frame(cols=character(n), types=character(n),colTypes=character(n),stringsAsFactors=FALSE)
    dfTypes$cols <- cols
    dfTypes$types <- as.character(lapply(data,class))
    dfTypes$colTypes <- paste(dfTypes$cols,"-",dfTypes$types)
    dfTypes  
  })
    
  output$myTable <- renderDataTable({
    data<-getDataset()
    
    if (length(input$colsDropDown)>0)
    {
      data <- data[input$colsDropDown]
    }
    
    if (length(input$typesDropDown)>0)
    {
      data <- switch (input$typesDropDown, 
                      All = data,                      
                      factor = as.data.frame(data[sapply(data,is.factor)]),                      
                      integer = data[sapply(data,is.integer)],
                      numeric = data[sapply(data,is.numeric)],
                      character = data[sapply(data,is.character)],
                      data
                      )
      
    }
    
    data    
  }, options = list(bSortClasses = TRUE, iDisplayLength = 10)) 
  
  
  output$myTableSchema <- renderDataTable({
    dfTypes <- getDataTypes()
    dfTypes
  }, options = list(bSortClasses = TRUE, iDisplayLength = 10)) 
  
  
  output$myDataset <- renderText({
    
    input$datasetSelect    
  })
  
  output$colsDropDown <- renderUI ({
    dfTypes <- getDataTypes()
    checkboxGroupInput("colsDropDown", "Names",
                       choices = dfTypes$cols,
                       selected = dfTypes$cols
                  )
  })
  
  output$typesDropDown <- renderUI ({
    dfTypes <- getDataTypes()
    types <- c("All",unique(dfTypes$types))
    
    selectInput("typesDropDown", "Types",
                       choices = types,
                       selected = "All"
    )
  })
  
  
  output$textTest <- renderText ({
    str(sapply(getDataset(),is.factor))
  })
  
})
