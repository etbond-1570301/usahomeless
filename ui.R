library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(ggmap)

raw.state.data <- read.csv('./data/HomelessPopulationState.csv', header = TRUE, stringsAsFactors = FALSE)

#removed row 55, the total row affected the map population ranges
state.data <- raw.state.data[-55,]

shinyUI(navbarPage(fluidPage("United States Homelessness"), theme="bootstrap.css",
                   tabPanel("Overview",
                            titlePanel('Project Overview'),
                            p("The issue of modern homelessness is broad and complex, affecting far too many of our neighbors and communities.
                              In fact, the true definition of homelessness is much broader than one might expect; simply stated as a person without a reliable shelter.
                              In attempt to visualize the severity of this issue, our project dives into a broad overview of homelessness within the United States,
                              and further depicts homeless data on a more local scale for a 'Close to Home', Washington-specific outlook on the data. 
                              The purpose of our report is to educate the general public on the intensity of homelessness within our country and to hopefully spark action among citizens, beginning on a local level. 
                              Though the causes of homelessness can be difficult to untangle, the ultimate observation comes down to a conflict between system and individual.
                              From the system perspective, a society with a lack of supportive and health services, a suffering economy, or a lack of affordable housing can be challenging for individuals on the brink of homelessness. From an individual perspective, these people can be classified as those unable to work without assistance, those able to work but are unemployed, and those who are employed. The grey areas in between, where the individual can't seem to succeed within the broader socio-political environment (however flawed it may be), are where conflicts happen that result in someone heading toward homelessness."),
                            h3("Timeline of Homelessness in the United States"),
                            p("Homelessness has taken many different forms throughout our history:"),
                            tags$ul(
                              tags$img(src = "https://homelessnessimages.files.wordpress.com/2017/12/img1.png", width = "700px", height = "400px"),
                              tags$img(src = "https://homelessnessimages.files.wordpress.com/2017/12/img2.png", width = "700px", height = "400px"),
                              tags$img(src = "https://homelessnessimages.files.wordpress.com/2017/12/img3.png", width = "700px", height = "400px"),
                              tags$img(src = "https://homelessnessimages.files.wordpress.com/2017/12/img4.png", width = "700px", height = "400px"),
                              tags$img(src = "https://homelessnessimages.files.wordpress.com/2017/12/img5.png", width = "700px", height = "400px")
                            )
                            ),
                   tabPanel("Food Banks in Seattle",
                              mainPanel(
                                plotOutput("foodBankPlot",
                                           hover = hoverOpts(id = "plot_hover")),
                                verbatimTextOutput("hover_info")
                              )
                            ),
                   tabPanel("USA",
                            
                            #State population map
                            sidebarPanel(
                              sliderInput('homelesspopulation',              # key this value will be assigned to
                                          "States with AT MOST:",  # label
                                          min = min(state.data$TotalHomeless2016),           # minimum slider value
                                          max = max(state.data$TotalHomeless2016),           # maximum slider value
                                          value = 1000          # starting value
                              ),
                              
                              ### allows the user to select a specific year and only see homeless data for that year.
                              radioButtons("datayear", "Year:",
                                           c("2007" = "2007",
                                             "2008" = "2008",
                                             "2009" = "2009",
                                             "2010" = "2010",
                                             "2011" = "2011",
                                             "2012" = "2012",
                                             "2013" = "2013",
                                             "2014" = "2014",
                                             "2015" = "2015",
                                             "2016" = "2016"))
                            ),
                            mainPanel(
                              plotlyOutput("plot"),
                              verbatimTextOutput("click")    
                            )),
                   tabPanel("Close to Home",
                            titlePanel("Homelessness In Washington State"),
                            sidebarLayout(
                              sidebarPanel("The top graph depicts the total number of homeless individuals per county (CoC) within Washington State.",
                                           br(), br(), "This graph can be adjusted by year using the drop-down list below:",
                                           br(), 
                                           selectInput(inputId = "Year",
                                                       label = "Year:",
                                                       choices = c("2007", "2008", "2009","2010", "2011", "2012", "2013", "2015", "2016", "All"),
                                                       selected = "All"),
                                           br(),
                                           "As you can see, the majority of Washington's homeless population can be attributed to the Seattle/King County region.
                                           The second graph displays an annual breakdown of the number of sheltered and non-sheltered homeless individuals within King county."),
                              
                              mainPanel(
                                plotOutput('waPlot'), 
                                br(), br(),
                                plotOutput('seaPlot')
                              ))),
                   
                   tabPanel("Documentation",
                            mainPanel( 
                              #HTML Formatted Text
                              h1("Project Documentation"),
                              h3("Created by: Jesus Quinones, Erika Bond, Joseph Leaptrott, Alexander Duong"),
                              br(), 
                              h2("Project Description"), 
                              h3("What is the data?"),
                              p("All the data sets we worked with can be found here: ###insert links here### "), 
                              p("Our data is based on information from the CoC (Continuum of Care Program) and provided to HUD (Department of Housing and Urban Development) 
                                on rates of homelessness by county in the United States. This data has statistics recorded from 2007 to 2016."),
                              br(),
                              h3("Why do we care?"),
                              p("This data teaches you about the obesity prevalence (prevalence by state) and visualizes the relationship between obesity prevalence 
                                and leisure-time devoted to physical activity. This information can be used by the those in the general public seeking to extract and acknowledge 
                                information regarding a given states homeless population breakdown. This audience would hopefully be individuals wanting to gain insights on this widespread
                                issue, get involved in helping homeless (via volunteer or lobbying efforts), or raise social consciousness regarding the homelessness in our country."),
                              br(),
                              "Some specific questions we are hoping that our audience leaves feeling more educated about are:",
                              tags$ul(
                                tags$li("What is the total homeless population by state? (And how does that data breakdown into different groupings into ‘types’ of homelessness (i.e. in shelters, chronically homeless, etc.)?"),
                                tags$li("What is a particular states homeless population by county?"),
                                tags$li("What is the difference in homeless population USA (or potential specific state)  from when the data started being collected (2006) to most recent entries (2016)?"),
                                tags$li("What are some of the resources available (shelters and food banks) in my area (Seattle)?")
                              ),
                              br(),
                              h2("Technical Description"),
                              h3("What libraries were used?"),
                              p("To create the visual representations we used ", 
                                #Linked Library Documentation
                                tags$a(href = "http://shiny.rstudio.com/", "shiny"), ", ",
                                tags$a(href = "https://plot.ly/r/", "plotly"), ", ",
                                tags$a(href = "https://cran.r-project.org/web/packages/choroplethr/", "choroplethr"), ", ",
                                tags$a(href = "https://cran.r-project.org/web/packages/choroplethrMaps/index.html", "choroplethrMaps"), ", and ",
                                tags$a(href = "http://ggplot.yhathq.com/", "ggplot"), ". "
                              ),
                              h3("What aspects of the data sets were used?")
                              
                              )
                              )
                   
                   )
        
)