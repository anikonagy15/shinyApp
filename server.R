library(shiny)
library(plyr)
library(ggplot2)
library(datasets)
library(chron)
library (dplyr)
library(stringr)
require(scales)
spaceFlights <- read.csv("Untitled 1.csv")
spaceFlights$Country <- spaceFlights$SPACECRAFT
v1 <- spaceFlights[grep("(USSR)", spaceFlights$Country), ]
v1$Country <- "USSR"
v2 <- spaceFlights[grep("(Russia)", spaceFlights$Country), ]
v2$Country <- "Russia"
v3 <- spaceFlights[grep("(USA)", spaceFlights$Country), ]
v3$Country <- "USA"
newSF <- rbind(v1,v2,v3)
newSF$REMARKS <- NULL
newSF$X <- NULL
newSF$X.1 <- NULL
newSF$X.2 <- NULL
newSF$X.3 <- NULL
newSF$X.4 <- NULL
newSF$X.5 <- NULL
newSF$X.6 <- NULL
newSF$X.7 <- NULL
newSF$Year <- newSF$LAUNCH
SF <- read.csv("newFS.csv")
SF$X <- NULL
SF$Country <- as.character(SF$Country)
SF$Country[SF$Country =="USSR" | SF$Country == "Russia"] <- "USSR/Russia"
SF <- arrange(SF, Year)
x <- filter(SF, Country == "USA")
x$cc <- 1
y <- select(x, c(Year, cc))
ys <- group_by(y, Year) %>% summarise_each(funs(sum))
z <- filter(SF, Country =="USSR/Russia")
z$cc <- 1
w <- select(z, c(Year, cc))
ws <- group_by(w, Year) %>% summarise_each(funs(sum))
names(ys)[names(ys)=="cc"] <- "USA"
names(ws)[names(ws)=="cc"] <- "USSR"
r <- merge(ys, ws, by="Year")
df <- data.frame(Year = (1961:2011))
df <- data.frame(Launch = c(r$USA, r$USSR))
df$Year <- c(r$Year, r$Year)
m <- matrix("USA", ncol = 1, nrow = 39)
b <- matrix("USSR", ncol =1, nrow =39)
f <- rbind(m,b)
df$Country <- f
df$Country[df$Country =="USSR" | df$Country == "Russia"] <- "USSR/Russia"

shinyServer(
        function(input, output){
                dat <- reactive({
                        if(input$Country == "All"){
                                SF %>% filter(Year >= input$Year[1], Year <=input$Year[2])
                        }
                        else{
                                SF %>% filter(Year >= input$Year[1], Year <=input$Year[2], Country ==input$Country )
                        }
                })
                     
                output$mydata <- renderDataTable({
                        dat()
                })
                
                data.r = reactive({
                        a <- subset(df, Year <= input$Year[2])
                        a <- subset(a, Year >= input$Year[1])
                        if (input$Country == "USSR/Russia") {
                                a <- subset(a, Country != "USA")
                        }
                        else if (input$Country == "USA"){
                                a <- subset(a, Country == "USA")
                        }
                        return(a)
                })
                output$plot <- renderPlot({
                        dd<-data.r()
                        graph <- ggplot(dd, aes(y=Launch, x=Year, fill=Country)) +
                                geom_bar(width=0.5, stat="identity", position="dodge") +
                                scale_x_continuous(breaks=pretty_breaks()) +
                                #scale_x_continuous(breaks=1961:2011 ) +
                                scale_y_continuous(breaks=pretty_breaks(n=10)) +
                                scale_fill_manual(values=c("#00BFC4", "#F8766D"))+ylab("Number of Launch")
                        print(graph)                        
                })
        })
