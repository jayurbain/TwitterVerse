# Jay Urbain
# Next word prediction
# 1/10/2016
# ui.R

require(shiny)
require(markdown)

shinyUI(
  navbarPage(
    "TwitterVerse", inverse = FALSE, collapsible = FALSE,
    tabPanel(
      "Word Prediction",
      sidebarPanel(
        width = 4,
        h5(
          "TwitterVerse uses a language model to predict the next word. Give it a try!"
        ),
        wellPanel(
          textInput("entry",
                    "Text input:",
                    "To be or not to"),
          radioButtons(
            "model", label = h5("Model"),
            choices = list(
              "Maximum Likelihood" = 1, "Maximum Specificity" = 2
            ),selected = 1
          )
        ),
        # submitButton('Predict'),
        helpText(
          "- Given a word, phrase, or sentence, the next word is predicted as your type."
        ),
        helpText(
          "- Predicted next words are listed with the input text in the main panel to the right."
        ),
        helpText(
          "- There is a delay of a few seconds when the app is first started to load the language models."
        ),
        hr(),
        helpText("Author: Jay Urbain")
      ),
      mainPanel(column(
        5,
        h3("Word Prediction"),
        hr(),
        h5('Input text:'),
        wellPanel(span(h5(textOutput(
          'sent'
        )), style = "color:green")),
        hr(),
        h5('Top-rated next word predictions:'),
        wellPanel(
          span(h5(textOutput('pred1')),style = "color:red"),
          span(h5(textOutput('pred2')),style = "color:black"),
          span(h5(textOutput('pred3')),style = "color:black"),
          span(h5(textOutput('pred4')),style = "color:black"),
          span(h5(textOutput('pred5')),style = "color:black")
        ),
        hr()
      ))
    ),
    tabPanel("Language Modeling",
             sidebarLayout(
               sidebarPanel("", width=0),
               mainPanel(
                 img(src = "language_modeling.png", width=600)
               )
             )
    ),
    tabPanel("Data Preparation",
             sidebarLayout(
               sidebarPanel("", width=0),
               mainPanel(
                 img(src = "data_preparation.png", width=600)
               )
             )
    ),
    tabPanel("TwitterVerse Model",
             sidebarLayout(
               sidebarPanel("", width=0),
               mainPanel(
                 img(src = "katz_lm.png", width=600)
               )
             )
    ))
)
