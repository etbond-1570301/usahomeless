library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(ggmap)
library(shinythemes)

raw.state.data <-
  read.csv(
    './data/HomelessPopulationState.csv',
    header = TRUE,
    stringsAsFactors = FALSE
  )

#removed row 55, the total row affected the map population ranges
state.data <- raw.state.data[-55, ]

shinyUI(
  navbarPage(
    fluidPage("United States Homelessness"),
    theme = shinythemes::shinytheme("cosmo"),
    tabPanel(
      "Overview",
      titlePanel('Project Overview'),
      p(
        "The issue of modern homelessness is broad and complex, affecting far too many of our neighbors and communities.
        In fact, the true definition of homelessness is much broader than one might expect; simply stated as a person without a reliable shelter.
        In attempt to visualize the severity of this issue, our project dives into a broad overview of homelessness within the United States,
        and further depicts homeless data on a more local scale for a 'Close to Home', Washington-specific outlook on the data.
        The purpose of our report is to educate the general public on the intensity of homelessness within our country and to hopefully spark action among citizens, beginning on a local level.",
        br(),
        br(),
        "Though the causes of homelessness can be difficult to untangle, the ultimate observation comes down to a conflict between system and individual.
        From the system perspective, a society with a lack of supportive and health services, a suffering economy, or a lack of affordable housing can be
        challenging for individuals on the brink of homelessness. From an individual perspective, these people can be classified as those unable to work
        without assistance, those able to work but are unemployed, and those who are employed. The grey areas in between, where the individual can’t seem
        to succeed within the broader socio-political environment (however flawed it may be), are where conflicts happen that result in someone heading toward homelessness."
      ),
      h3("Timeline of Homelessness in the United States"),
      p(
        "Homelessness has taken many different forms throughout our history:"
      ),
      tags$ul(
        tags$img(
          src = "https://homelessnessimages.files.wordpress.com/2017/12/img1.png",
          width = "700px",
          height = "400px"
        ),
        tags$img(
          src = "https://homelessnessimages.files.wordpress.com/2017/12/img2.png",
          width = "700px",
          height = "400px"
        ),
        tags$img(
          src = "https://homelessnessimages.files.wordpress.com/2017/12/img3.png",
          width = "700px",
          height = "400px"
        ),
        tags$img(
          src = "https://homelessnessimages.files.wordpress.com/2017/12/img4.png",
          width = "700px",
          height = "400px"
        ),
        tags$img(
          src = "https://homelessnessimages.files.wordpress.com/2017/12/img5.png",
          width = "700px",
          height = "400px"
        )
      )
      ),
    tabPanel(
      "USA",
      titlePanel("Homelessness In United States"),
      br(), br(),
      sidebarPanel(
        "The slider below allows the user to view states with homeless populations at or below the slider value.",
        br(),
        br(),
        sliderInput(
          'homelesspopulation',
          "Homeless Population:",
          # label
          min = min(state.data$TotalHomeless2016),
          # minimum slider value
          max = max(state.data$TotalHomeless2016),
          # maximum slider value
          value = 1000          # starting value
        ),
        
        "These radio buttons allow the user to select a specific year and view United States homeless data for only that year.",
        br(),
        br(),
        radioButtons(
          "datayear",
          "Year:",
          c(
            "2007" = "2007",
            "2008" = "2008",
            "2009" = "2009",
            "2010" = "2010",
            "2011" = "2011",
            "2012" = "2012",
            "2013" = "2013",
            "2014" = "2014",
            "2015" = "2015",
            "2016" = "2016"
          )
        )
      ),
      mainPanel(
        p(
          "This map depicts the specific state's homeless populations based on the year of input. Hovering over a state will provide
          the user with state-specific homeless data regarding total number of homeless individuals, and a breakdown of those individuals in and out of homeless shelters."
        ),
        plotlyOutput("plot"),
        verbatimTextOutput("click")
        )
    ),
    
    tabPanel(
      "Close to Home",
      titlePanel("Homelessness In Washington State"),
      br(), br(),
      sidebarLayout(
        sidebarPanel(
          "The graph to the right depicts the total number of homeless individuals per county (CoC) within Washington State.",
          br(),
          br(),
          "This graph can be adjusted by year using the drop-down list below:",
          br(),
          br(),
          selectInput(
            inputId = "Year",
            label = "Year:",
            choices = c(
              "2007",
              "2008",
              "2009",
              "2010",
              "2011",
              "2012",
              "2013",
              "2015",
              "2016",
              "All"
            ),
            selected = "All"
          )
        ),
        
        mainPanel(
          plotOutput('waPlot'),
          br(),
          br(),
          p(
            "As you can see, the majority of Washington's homeless population can be attributed to the Seattle/King County region.
            The graph below displays an annual breakdown of the number of sheltered and non-sheltered homeless individuals within King county."
          ),
          br(),
          br(),
          plotlyOutput('seaPlot'),
          br(),
          br(),
          p(
            "As the intensity of homelessness in the United States shows no major decrease, the issue of hunger continues to prevail. 46.5 million Americans — more than the entire populations of New York, Pennsylvania, and Illinois combined — don’t have enough food to eat.
            In the coming years, that number is only going to get bigger, unless people step in to help in a big way. This said, food banks are uniquely qualified to address America’s
            hunger crisis. They’ve long accomplished the boots-on-the-ground work, despite years of crippling cuts to food assistance programs on both a state-by-state and national level.
            Food banks receive federal funding and corporate gifts, but donations from individuals make up the majority of the budget used to feed people at soup kitchens, food pantries, and meal
            programs across the country.",
            br(),
            br(),
            "If you are interested in contributing on a local level, the map below provides information on all of the food banks in Seattle. You can hover over a mapped point for the address and website
            of a food bank in the area."
          ),
          br(),
          br(),
          
          plotOutput(
            "foodBankPlot",
            hover = hoverOpts(id = "plot_hover"),
            click = clickOpts(id = "plot_click"),
            brush = brushOpts(id = "plot_brush", resetOnNew = TRUE),
            dblclick = "plot_doubleClick"
          ),
          fluidRow(
            column(width = 1),
            column(width = 10,
                   verbatimTextOutput("info")),
            column(width = 1)
          )
          
          )
        )
    ),
    
    tabPanel(
      "Documentation",
      mainPanel(
        #HTML Formatted Text
        h1("Project Documentation"),
        h3(
          "Created by: Jesus Quinones, Erika Bond, Joseph Leaptrott, Alexander Duong"
        ),
        br(),
        h2("Project Description"),
        h3("What is the data?"),
        p(
          "All the data sets we worked with can be found at",
          #Linked Library Documentation
          tags$a(href = "http://shiny.rstudio.com/", "Kaggle"),
          "and at",
          tags$a(href = "https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/", "HUD exchange"),
          "."
        ),
        p(
          "Our data is based on information from the CoC (Continuum of Care Program) and provided to HUD (Department of Housing and Urban Development)
          on rates of homelessness by county in the United States. This data has statistics recorded from 2007 to 2016."
        ),
        br(),
        h3("Why do we care?"),
        p(
          "This data teaches users about the homeless prevalence (prevalence by state) and visualizes the break down the amount of homeless individuals that either have or do not have access to homeless shelters.
          This information can be used by the those in the general public seeking to extract and acknowledge
          information regarding a given state’s homeless population breakdown. This audience would hopefully be individuals wanting to gain insights on this widespread
          issue, get involved in helping homeless (via volunteer or lobbying efforts), or raise social consciousness regarding the homelessness in our country. We targeted our findings in the 'Close to Home' tab pannel
          towards individuals in our state (Washington) and area (Seattle), so that we could raise awareness in our community and help people better relate to the widespread issue on a more local scale."
        ),
        br(),
        "Some specific questions we are hoping that our audience leaves feeling more educated about are:",
        tags$ul(
          tags$li(
            "What is the total homeless population by state? (And how does that data breakdown into different groupings into ‘types’ of homelessness (i.e. in shelters, chronically homeless, etc.)?"
          ),
          tags$li("What is a particular state’s homeless population by county?"),
          tags$li(
            "What does the US homeless population (by state) look like from when the data started being collected (2006) to most recent entries (2016)?"
          ),
          tags$li(
            "What does the issue look like in my area (Seattle/WA)? What can I (the user) do to help?"
          )
        ),
        br(),
        h3("What libraries were used?"),
        p(
          "To create the visual representations we used ",
          #Linked Library Documentation
          tags$a(href = "http://shiny.rstudio.com/", "shiny"),
          ", ",
          tags$a(href = "https://plot.ly/r/", "plotly"),
          ", ",
          tags$a(href = "https://cran.r-project.org/web/packages/choroplethr/", "choroplethr"),
          ", ",
          tags$a(href = "https://cran.r-project.org/web/packages/choroplethrMaps/index.html", "choroplethrMaps"),
          ", and ",
          tags$a(href = "http://ggplot.yhathq.com/", "ggplot"),
          ". "
        )
        
        )
        )
    
    )
  
  )
