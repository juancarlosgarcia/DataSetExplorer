
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
  
  getDatasetFiltered <- reactive({
    data<-getDataset()
    cols <- colnames(data)
    
    if (!is.null(input$colsDropDown))
    {
      if (length(intersect(cols,input$colsDropDown))>0)        
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
                      logical = data[sapply(data,logical)],
                      data
      )
      
    }
    
    data     
  })
  
  output$myTable <- renderDataTable({
    data<-getDatasetFiltered()
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
    checkboxGroupInput("colsDropDown", "Filter by Names",
                       choices = dfTypes$cols,
                       selected = dfTypes$cols
                  )
  })
  
  output$typesDropDown <- renderUI ({
    dfTypes <- getDataTypes()
    types <- c("All",unique(dfTypes$types))
    
    selectInput("typesDropDown", "Filter by Types",
                       choices = types,
                       selected = "All"
    )
  })
  
  output$colsXDropDown <- renderUI ({
    data<-getDatasetFiltered()
    cols<-colnames(data)
    selectInput("colsXDropDown", "X Variable",
                       choices = cols,
                       selected = cols[1]
    )
  })
  
  output$colsYDropDown <- renderUI ({
    data<-getDatasetFiltered()
    cols<-colnames(data)
    selectInput("colsYDropDown", "Y Variable",
                       choices = cols,
                       selected = cols[1]
    )
  })
  
  output$textTest <- renderText ({
    "jc"
  })
  
  output$textTest2 <- renderText ({
    "jc"
  })
  
})
