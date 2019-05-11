library(shiny)

# fields we want to save
fields <- c("date", "team", "player", "location", "hit", "result")

ui <- fluidPage(
  DT::dataTableOutput("responses", width = 300), tags$hr(),
  titlePanel("UST Men's Baseball"),
  sidebarLayout(
    sidebarPanel(
      dateInput("date",
        label = "Date:",
        value = NULL,
        min = NULL,
        max = NULL,
        format = "mm-dd-yyyy",
        startview = "month",
        weekstart = 0,
        language = "en",
        width = NULL,
        autoclose = TRUE,
        datesdisabled = NULL,
        daysofweekdisabled = NULL
      ),
      selectInput("team",
        label = "Team:",
        choices = list(
          "Augsburg University",
          "Bethel University",
          "Carleton College",
          "Concordia (III.)",
          "Concordia-Moorhead College",
          "Gustavus Adolphus College",
          "Hamline University",
          "Macalester College",
          "Saint John's University",
          "Saint Mary's University",
          "St. Olaf College",
          "University of St. Thomas",
          "UW-La Crosse",
          "UW-Oshkosh",
          "UW-Stout",
          "Wartburg",
          "Other"
        ),
        selected = "University of St. Thomas"
      ),
      numericInput("player",
        label = "Player Number:",
        value = 00,
        min = 00,
        max = 99,
        step = 1,
        width = NULL
      ),
      numericInput("location",
        label = "Location of Hit:",
        value = 00,
        min = 0,
        max = 12,
        step = 1,
        width = NULL
      ),
      selectInput("hit",
        label = "Type of Hit:",
        choices = list(
          "None",
          "Ground Ball",
          "Line Drive",
          "Pop Fly"
        )
      ),
      selectInput("result",
        label = "Batting Result:",
        choices = list(
          "Out",
          "Walk",
          "Single",
          "Double",
          "Triple",
          "Home Run"
        )
      ),
      img(src = "UST.logo_.c.jpg", height = "100%", width = "100%")
    ),
    mainPanel(
      img(src = "field.png", height = "75%", width = "75%"),
      br(),
      actionButton("submit", "Submit", style = "float:right")
    )
  )
)

library(googlesheets)
suppressPackageStartupMessages(library(dplyr))

table <- "responses"

saveData <- function(data) {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}

loadData <- function() {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Read the data
  gs_read_csv(sheet)
}




server <- function(input, output) {
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  observeEvent(input$submit, {
    saveData(formData())
  })
  # Show the previous responses
  # (update with current response when Submit is clicked)
  output$responses <- DT::renderDataTable({
    input$submit
    loadData()
  })
}

shinyApp(ui = ui, server = server)
