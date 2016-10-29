library(shiny)
library(shinythemes)

shinyUI(
  fluidPage(theme = shinytheme("flatly"),

  # Application title
  titlePanel("COP Forex Prediction Model"),

  # Sidebar with input boxes for forecasted oil values
  sidebarLayout(
    sidebarPanel(
      numericInput("box1", "Forecast WTI oil barril (i.e. 50.75): ", 40.0, min = 0.0, max = 120),
      numericInput("box2", "Forecast Brent oil barril (i.e. 49.75): ", 40.0, min = 0.0, max = 120),
      submitButton("PREDICT"),
      br(),
      h6("DOCUMENTATION"),
      p("It is a widely accepted fact among economist that the Colombian Peso exchange rate is tied to the prices of WTI and Brent oil barril, 
        given the country's large oil industry. Analyst and traders follow complicated statistical models in order to judge the volatility of the
        peso (COP) and play the forex market."),
      br(),
      p("In order to predict FOREX for Colombian peso, simply input your estimate of prices for WTI and Brent oil barril."),
      p("My Machine Learning algorithm work with training and testing data updated to March 2016."),
      br(),
      p("COP FOREX TODAY"),
      textOutput("cop")
    ),

    # Tab panel with plots and predictions according to ML models
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("WTI Model", br(), plotOutput("plot1"), br(), textOutput("out1")),
                  tabPanel("Brent Model", br(), plotOutput("plot2"), br(), textOutput("out2")),
                  tabPanel("Composite Model", br(), plotOutput("plot3"), br(), textOutput("out3"))
    )
  )
))
)

