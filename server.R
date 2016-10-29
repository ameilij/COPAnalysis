# server.R
# The server part of the program creates updated machine learning prediction models
# of the Colombian peso forex based on the trending prices of WTI and Brent oil barrils.
# The models are based on the GLM, LM, and Random Forest algorithms.

library(shiny)

#Read and review file values
oilvscop = read.csv("oilvscop_wti_brent_numeric.csv")
oilvscop$date <- as.Date(oilvscop$date, origin = "1899-12-30")

# Use Machine Learning to build 3 favorite models of COP prediction
library(caret)
library(lattice)
library(ggplot2)
inTrain <- createDataPartition(y = oilvscop$forex, p = 0.7, list = FALSE)
training <- oilvscop[inTrain, ]
testing <- oilvscop[-inTrain, ]

# Model 1 GLM, model 2 LM, model 3 RF
model1 <- train(forex ~ wti, data = oilvscop, method = "glm")
model2 <- train(forex ~ brent, data = oilvscop, method = "glm")
model3 <- train(forex ~ wti * brent, data = oilvscop, method = "glm")

shinyServer(function(input, output) {
  
  predictionWTI <- reactive ({
    predWTI = round(predict(model1, newdata = data.frame(wti = input$box1, brent = input$box2)),2)
    r2WTI = round(model1[[4]][3],2)
    return(c(predWTI, r2WTI))
  })
  
  predictionBrent <- reactive({
    predBrent = round(predict(model2, newdata = data.frame(wti = input$box1, brent = input$box2)),2)
    r2Brent = round(model2[[4]][3],2)
    return(c(predBrent, r2Brent))
  })
  
  predictionComposite <- reactive({
    predComposite = round(predict(model3, newdata = data.frame(wti = input$box1, brent = input$box2)),2)
    r2Composite = round(model3[[4]][3],2)
    return(c(predComposite, r2Composite))
  })

  textS1 <- "Forecast for COP using model "
  output$out1 <- renderText(paste(textS1, "WTI", predictionWTI()[1], "    | R-square: ", predictionWTI()[2]))
  output$out2 <- renderText(paste(textS1, "Brent", predictionBrent()[1], "    | R-square: ", predictionBrent()[2]))
  output$out3 <- renderText(paste(textS1, "Composite", predictionComposite()[1], "    | R-square: ", predictionComposite()[2]))

  output$plot1 <- renderPlot({
    qplot(testing$forex, predict(model1, testing), colour = forex, data = testing) + geom_smooth(method = "lm") + 
      xlab("Real Forex Value") + ylab("FOREX prediction")
  })
  
  output$plot2 <- renderPlot({
    qplot(testing$forex, predict(model2, testing), colour = forex, data = testing) + geom_smooth(method = "lm") + 
      xlab("Real Forex Value") + ylab("FOREX prediction")
  })
  
  output$plot3 <- renderPlot({
    qplot(testing$forex, predict(model3, testing), colour = forex, data = testing) + geom_smooth(method = "lm") + 
      xlab("Real Forex Value") + ylab("FOREX prediction")
  })
  
})
