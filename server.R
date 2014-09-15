
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(UsingR)

shinyServer(function(input, output) {

  getDataset <- reactive({
    
    data <- switch (input$datasetSelect, 
                    iris = iris,
                    mtcars = mtcars,
                    diamond = diamond)
    data
  })
  
  output$myTable <- renderDataTable({
    getDataset()
  }, options = list(bSortClasses = TRUE, iDisplayLength = 10)) 
  
  output$myDataset <- renderText({

    input$datasetSelect

  })

})
