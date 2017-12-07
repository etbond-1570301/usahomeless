library(shiny)
library(dplyr)
library(ggplot2)
library(ggmap)
library(shinythemes)


#Set working directory:
#setwd("~/Desktop/info201/usahomelessness") 

#Read in data.
homeless.df <- read.csv('./data/homeless.csv')

raw.state.data <- read.csv('./data/HomelessPopulationState.csv', header = TRUE, stringsAsFactors = FALSE)
#removed row 55, the total row affected the map population ranges
state.data <- raw.state.data[-55,]

##WA Dataframes.
#Filter data for Washington only.
wa.plot.data <- filter(homeless.df, State == 'WA', Measures == "Total Homeless") %>%
  select(State, Count, Year, Measures, CoC.Name)
#Add new column that eliminates commas from Count for graphic plotting.
wa.plot.data$Count2 = as.numeric(gsub("\\,", "", wa.plot.data$Count))
#Create data frame for necessary Seattle plot data.
sea.plot.data <- filter(homeless.df, State == "WA", CoC.Name == "Seattle/King County CoC", Measures %in% c("Sheltered Homeless", "Unsheltered Homeless")) %>%
  select(State, Count, Year, Measures, CoC.Name)
#Remove commas for plotting.
sea.plot.data$Count2 = as.numeric(gsub("\\,", "", sea.plot.data$Count))

#Food Bank
food <- read.csv("data/Food_Banks.csv", stringsAsFactors = FALSE)

#######################################################################

##Server

shinyServer(function(input, output) {


##Overview.

  
##USA Homelessness. 
  
  output$plot <- renderPlotly({

    #actively filters the data according to user input (by year and only shows states with total homeless populations <= user input)
    state.data <- state.data %>%
                  select(State, contains(toString(input$datayear))) %>%
                  filter(state.data$TotalHomeless2016 <= input$homelesspopulation)
                  
    #stores total population, sheltered homeless, and unsheltered homeless as arrays.
    Population <- state.data[ , 2]
    Sheltered <- state.data[, 3]
    Unsheltered <- state.data[ , 4]
    
    state.data$hover <- with(state.data, paste(State, '<br>', "Total Homeless", Population, "Sheltered Homeless", Sheltered, "<br>",
                                                       "Unsheltered Homeless", Unsheltered))
    
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      lakecolor = toRGB('white')
    )
    plot_ly(state.data, z = ~Population, text = ~state.data$hover, locations = ~State,
            type = 'choropleth', locationmode = 'USA-states') %>%
      layout(geo = g)
  })
  
  output$click <- renderPrint({
    d <- event_data("plotly_click")
  })
  
  
##Washington.
output$waPlot <- renderPlot({
  
  #Filter the dataset based on manufacturer input.
   if(input$Year == "2007") {
   plot.data = wa.plot.data %>% filter(Year == "1/1/2007")
  } else if (input$Year == "2008") {
   plot.data = wa.plot.data %>% filter(Year == "1/1/2008")
   } else if (input$Year == "2009") {
    plot.data = wa.plot.data %>% filter(Year == "1/1/2009")
    } else if (input$Year == "2010") {
     plot.data = wa.plot.data %>% filter(Year == "1/1/2010")
    } else if (input$Year == "2011") {
    plot.data = wa.plot.data %>% filter(Year == "1/1/2011")
    } else if (input$Year == "2012") {
     plot.data = wa.plot.data %>% filter(Year == "1/1/2012")
    } else if (input$Year == "2013") {
     plot.data = wa.plot.data %>% filter(Year == "1/1/2013")
     } else if (input$Year == "2014") {
      plot.data = wa.plot.data %>% filter(Year == "1/1/2014")
   } else if (input$Year == "2015") {
    plot.data = wa.plot.data %>% filter(Year == "1/1/2015")
   } else if (input$Year == "2016") {
      plot.data = wa.plot.data %>% filter(Year == "1/1/2016")
   } else {
      plot.data = wa.plot.data
   }
  
  #Using the defined values, construct a WA barplot using ggplot2
  ggplot(plot.data, aes(x=Year, y=Count2, fill = CoC.Name)) + 
  geom_bar(stat="identity", aes(color= CoC.Name), position=position_dodge()) +
    theme(axis.text.x = element_text(size  = 10, angle = 45, hjust = 1, vjust = 1)) +
    theme(axis.text.y = element_text(size = 10, hjust = 1, vjust = 1)) +
    labs(title = "Annual Homeless Population By Washington County", x = "Year of Data Collection", y = "Homeless Individuals")
})

output$seaPlot <- renderPlot({
  if(input$Year == "2007") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2007")
  } else if (input$Year == "2008") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2008")
  } else if (input$Year == "2009") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2009")
  } else if (input$Year == "2010") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2010")
  } else if (input$Year == "2011") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2011")
  } else if (input$Year == "2012") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2012")
  } else if (input$Year == "2013") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2013")
  } else if (input$Year == "2014") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2014")
  } else if (input$Year == "2015") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2015")
  } else if (input$Year == "2016") {
    plot.data = sea.plot.data %>% filter(Year == "1/1/2016")
  } else {
    plot.data = sea.plot.data
  }
  
  
    ggplot(data=sea.plot.data, aes(Year, factor(Count2), fill=Measures)) +
    geom_bar(stat="identity", aes(color= Measures), position=position_dodge()) +
    theme_minimal() + 
    theme(axis.text.x = element_text(size  = 10, angle = 45, hjust = 1, vjust = 1)) +
    theme(axis.text.y = element_text(size = 7, hjust = 1, vjust = 1)) +
    labs(title = "Annual Homeless Breakdown (King County)", x = "Year of Data Collection", y = "Sheltered/Unsheltered Homeless Individuals")
  
  
})
  
  #Food Bank Plot
  output$foodBankPlot <- renderPlot({
    
    map.seattle_city <- qmap("seattle", zoom = 11, source="stamen", maptype="toner",darken = c(.3,"#BBBBBB"))
    map.seattle_city
    
    map.seattle_city +
      geom_point(data=food, aes(x=Longitude, y=Latitude), color = "orange", alpha = 0.7, size = 6.0)
    
  })
  
  #Food Bank Plot Hover Hack
  output$hover_info <- renderText({
    
    if(!is.null(input$plot_hover)){
      hover = input$plot_hover
      dist = dist=sqrt((hover$x-food$Longitude)^2+(hover$y-food$Latitude)^2)
      if(min(dist) < 3) {
        paste0("Food Bank: ", food$Common.Name[which.min(dist)], "\n",
               "Address: ", food$Address[which.min(dist)], "\n",
               "Website: ", food$Website[which.min(dist)])
      }
    }
  })

})