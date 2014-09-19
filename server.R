
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(UsingR)
library(datasets)
library(ggplot2)

shinyServer(function(input, output) {
  
  getDataset <- reactive({
    if (is.null(input$datasetSelect))
      return()
    
    data <- switch (input$datasetSelect, 
                    iris = iris,
                    mtcars = mtcars,
                    diamond = diamond,
                    diamonds = diamonds,
                    airquality  = airquality )    
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
  
  
  #Cluster Explorer
  #===================================
  getDatasetCluster <- reactive({
    data<-getDatasetFiltered()
    
    data<-data[c(input$colsXDropDown,input$colsYDropDown)]
    data<-data[complete.cases(data),]
    data
  })
  
  clusters <- reactive({
    data <- getDatasetCluster()
    kmeans(data, input$clusters)
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
 
    output$plotCluster <- renderPlot({
      par(mar = c(5.1, 4.1, 0, 1))
      plot(getDatasetCluster(),
           col = clusters()$cluster,
           pch = 20, cex = 3)
      points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    })
    
#Plot Exploration

  output$plotXDropDown <- renderUI ({
    data<-getDatasetFiltered()
    cols<-colnames(data)
    selectInput("plotXDropDown", "X",
                choices = cols,
                selected = cols[1]
    )
  })
  
  output$plotYDropDown <- renderUI ({
    data<-getDatasetFiltered()
    cols<-colnames(data)
    selectInput("plotYDropDown", "Y",
                choices = cols,
                selected = cols[1]
    )
  })
  
  output$plotColorDropDown <- renderUI ({
    data<-getDatasetFiltered()
    cols<-c("None",colnames(data))
    selectInput("plotColorDropDown", "Color",
                choices = cols,
                selected = cols[1]
    )
  })
  
  output$plotFacetRowDropDown <- renderUI ({
    data<-getDatasetFiltered()
    data<-data[!sapply(data,is.numeric)]
    cols<-c(None='.',colnames(data))
    selectInput("plotFacetRowDropDown", "Facet Row",
                choices = cols,
                selected = cols[1]
    )
  })
  
  output$plotFacetColDropDown <- renderUI ({
    data<-getDatasetFiltered()
    data<-data[!sapply(data,is.numeric)]
    cols<-c(None='.',colnames(data))
    selectInput("plotFacetColDropDown", "Facet Col",
                choices = cols,
                selected = cols[1]
    )
  })
  
  getDatasetPlot <- reactive({
    data<-getDatasetFiltered()
    
    #data<-data[c(input$plotXDropDown,input$plotYDropDown,input$plotColorDropDown,input$plotFacetRowDropDown,input$plotFacetColDropDown)]
    #data<-data[complete.cases(data),]
    data
  })
  
  output$plotExplorer <- renderPlot({
    data<-getDatasetPlot()
    p <- ggplot(data, aes_string(x=input$plotXDropDown, y=input$plotYDropDown)) + geom_point()
    
    if (input$plotColorDropDown != 'None')
      p <- p + aes_string(color=input$plotColorDropDown)
    
    facets <- paste(input$plotFacetRowDropDown, '~', input$plotFacetColDropDown)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    
#     if (input$jitter)
#       p <- p + geom_jitter()
#     if (input$smooth)
#       p <- p + geom_smooth()
    
    print(p)
    
  })

  output$textTest <- renderText ({
    "jc"
  })
  
  output$textTest2 <- renderText ({
    "jc"
  })
  
})
