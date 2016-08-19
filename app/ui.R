library(shiny)

fluidPage(
  titlePanel("Word prediction"),
  sidebarPanel(
    h3('How to use:'),
    helpText('Just start typing') 
  ),
  
  mainPanel(
    textInput('text', 'Text:', placeholder = 'Start typing here...'),
    verbatimTextOutput('predictions')
  )
)