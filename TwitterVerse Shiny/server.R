# Jay Urbain
# Next word prediction
# 1/10/2016
# server.R

require(shiny)
load('df_uniGram.RData',.GlobalEnv)
load('df_biGram.RData',.GlobalEnv)
load('df_triGram.RData',.GlobalEnv)
load('df_quadGram.RData',.GlobalEnv)
source('Predict.R')

shinyServer(function(input, output) {

    dataInput <- reactive(predictNgramKB(input$entry, (input$model=='2')))

    output$pred1 <- renderText({
        paste("1:", input$entry, dataInput()[1])
    })
    output$pred2 <- renderText({
        paste("2:", input$entry, dataInput()[2])
    })
    output$pred3 <- renderText({
        paste("3:", input$entry, dataInput()[3])
    })
    output$pred4 <- renderText({
        paste("4:", input$entry, dataInput()[4])
    })
    output$pred5 <- renderText({
        paste("5:", input$entry, dataInput()[5])
    })

    output$text <- renderText({
        dataInput()
    })
    output$sent <- renderText({
        input$entry
    })

    # Define a reactive expression for the document term matrix
    # terms <- reactive(predictWordcloud(input$entry))
    terms <- reactive({
        input$update
        isolate({predictWordcloud(input$entry)})
    })
})
