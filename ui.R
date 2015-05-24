library(shiny)
library(ggplot2)
require(markdown)
SpaceFlights <- read.csv("Untitled 1.csv")

shinyUI(pageWithSidebar(
        headerPanel("Manned Space Flights"),
        sidebarPanel(
                selectInput("Country", "Country:",
                            choices <- c("USSR/Russia","USA", "All")),
                sliderInput("Year",
                           label = "Year:",sep="",
                           min = 1961, max = 2011, value = c(1961, 2011), step = 1)),

                mainPanel(
                #dataTableOutput('mydata')
                        tabsetPanel (
                                tabPanel ("Table", h4 ("Table of Space Flights"),
                                          dataTableOutput ("mydata")),
                                tabPanel ("Graph", h4 ("Total Number of Space Flights"),
                                          plotOutput ("plot")),
                                tabPanel ("About", h4 ("About this Application"),
                                          includeMarkdown ("AboutPage.md")
                                
                                          )
                        )
                )
        
   
))
