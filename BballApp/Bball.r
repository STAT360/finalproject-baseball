library(shiny)

# fields we want to save
fields <- c("date", "team", "player", "pitch", "location", "hit", "result")

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
      selectInput("pitch",
        label = "Type of Pitch:",
        choices = list(
          "Fastball",
          "Curve Ball",
          "Slider",
          "Change Up"
        )
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
      img(src = "USTlogo.jpg", height = "100%", width = "100%")
    ),
    mainPanel(
      textOutput("selected_var1"),
      textOutput("selected_var2"),
      img(src = "diamond.png", height = "85%", width = "85%"),
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

server <- function(input, output, session) {
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  observeEvent(input$submit, {
    saveData(formData())
    # updatedateInput(session, "date")
    updateSelectInput(session, "team",
      choices = c(
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
      ), selected = "University of St. Thomas"
    )
    updateNumericInput(session, "player", value = 0)
    updateSelectInput(session, "pitch",
      choices = c(
        "Fastball",
        "Curve Ball",
        "Slider",
        "Change Up"
      ), selected = "Fastball"
    )
    updateNumericInput(session, "location", value = 0)
    updateSelectInput(session, "hit",
      choices = c(
        "None",
        "Ground Ball",
        "Line Drive",
        "Pop Fly"
      ), selected = "None"
    )
    updateSelectInput(session, "result",
      choices = c(
        "Out",
        "Walk",
        "Single",
        "Double",
        "Triple",
        "Home Run"
      ), selected = "Out"
    )
    output$selected_var1 <- renderText({ 
    paste("Player number", input$player, "from", input$team, "typically hits the ball:")
        })
    output$selected_var2 <- renderText({ 
    paste("Need the data")
        }) 
  })
  # Show the previous responses
  # (update with current response when Submit is clicked)
  output$responses <- DT::renderDataTable({
    input$submit
    loadData()
  })
}

shinyApp(ui = ui, server = server)
