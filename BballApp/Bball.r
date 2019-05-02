library(shiny)

ui <- fluidPage(
  titlePanel("UST Men's Baseball"),
  sidebarLayout(
    sidebarPanel(
      dateInput("var", 
                label = "Date:", 
                value = NULL, 
                min = NULL, 
                max = NULL,
                format = "mm-dd-yy", 
                startview = "month", 
                weekstart = 0,
                language = "en", 
                width = NULL, 
                autoclose = TRUE,
                datesdisabled = NULL, 
                daysofweekdisabled = NULL),
      selectInput("var", 
                  label = "Team:",
                  choices = list("Augsburg University", 
                                 "Bethel University",
                                 "Carleton College",
                                 "Concordia College",
                                 "Gustavus Adolphus College",
                                 "Hamline University",
                                 "Macalester College",
                                 "Saint John's University",
                                 "St. Olaf College",
                                 "University of St. Thomas"),
                  selected = "University of St. Thomas"),
      numericInput("var", 
                   label = "Player Number:", 
                   value = 00, 
                   min = 00, 
                   max = 99, 
                   step = 1,
                   width = NULL),
      selectInput("var", 
                  label = "Type of Hit:",
                  choices = list("None",
                                 "Ground Ball",
                                 "Line Drive",
                                 "Pop Fly")),
      selectInput("var", 
                  label = "Batting Result:",
                  choices = list("Out",
                                 "Single",
                                 "Double",
                                 "Triple",
                                 "Home Run")),
      img(src = "USTlogo.jpg", height = 100, width = 235)
    ),
    mainPanel(
      tags$head(tags$script(src = "message-handler.js")),
      actionButton(style ="display:inline-block;width:20%;text-align:center;","do", "Next", style="float:right"),
      br(),
      img(src = "field.png", height = 450, width = 450),
      br(),
      tags$head(tags$script(src = "message-handler.js")),
      actionButton(style ="display:inline-block;width:20%;text-align:center;","do", "End Game", style="float:right")
    )
  )
)

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)
