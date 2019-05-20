library(shiny)

# fields we want to save
fields <- c("date", "team", "player", "pitch", "location", "hit", "result")

# user interface
ui <- fluidPage(
  # title
  titlePanel("UST Men's Baseball"),
  # sidebar
  sidebarLayout(
    sidebarPanel(
      # input a date
      textInput("date",
        label = "Date (mm-dd-yyyy):"
      ),
      # choose a team
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
        # default team selection
        selected = "University of St. Thomas"
      ),
      # input a player number
      numericInput("player",
        label = "Player Number:",
        value = 00,
        min = 00,
        max = 99,
        step = 1,
        width = NULL
      ),
      # choose a type of pitch
      selectInput("pitch",
        label = "Type of Pitch:",
        choices = list(
          "Fastball",
          "Curve Ball",
          "Slider",
          "Change Up"
        )
      ),
      # input location number
      numericInput("location",
        label = "Location of Hit:",
        value = 00,
        min = 0,
        max = 12,
        step = 1,
        width = NULL
      ),
      # choose a type of hit
      selectInput("hit",
        label = "Type of Hit:",
        choices = list(
          "None",
          "Ground Ball",
          "Line Drive",
          "Pop Fly"
        )
      ),
      # choose a batting result
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
      # UST logo image
      img(src = "USTlogo.jpg", height = "100%", width = "100%")
    ),
    # main panel
    mainPanel(
      # tabs
      tabsetPanel(
        type = "tabs",
        # tab 1
        tabPanel(
          "Field",
          # field with numbered locations image
          img(src = "diamond.png", height = "85%", width = "85%"),
          br(),
          # submit button
          actionButton("submit", "Submit", style = "float:right")
        ),
        # tab 2
        tabPanel(
          "Data",
          # create a container for response table
          DT::dataTableOutput("responses"), tags$hr()
        ),
        # tab 3
        tabPanel(
          "Likelihood",
          # create a container for likelihood table
          DT::dataTableOutput("likeli"), tags$hr()
        )
      )
    )
  )
)

# load packages
library(googlesheets)
suppressPackageStartupMessages(library(dplyr))

table <- "responses"

saveData <- function(data) {
  # grab the google sheet
  sheet <- gs_title(table)
  # add the data as a new row
  gs_add_row(sheet, input = data)
}

loadData <- function() {
  # grab the google sheet
  sheet <- gs_title(table)
  # read the data
  gs_read_csv(sheet)
}

# data wrangling for likelihood table
likelihood <- gs_title("responses")
like <- likelihood %>% gs_read(ws = "Sheet1")
l <- like %>% group_by(team, player, location) %>% summarise(n = n())

# server
server <- function(input, output, session) {
  # collect form data
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  # save form data when submit button is clicked
  observeEvent(input$submit, {
    saveData(formData())
    # after submit, defaul team to UST
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
    # after submit, defaul player to 0
    updateNumericInput(session, "player", value = 0)
    # after submit, defaul pitch to fastball
    updateSelectInput(session, "pitch",
      choices = c(
        "Fastball",
        "Curve Ball",
        "Slider",
        "Change Up"
      ), selected = "Fastball"
    )
    # after submit, defaul location to 0
    updateNumericInput(session, "location", value = 0)
    # after submit, defaul hit to none
    updateSelectInput(session, "hit",
      choices = c(
        "None",
        "Ground Ball",
        "Line Drive",
        "Pop Fly"
      ), selected = "None"
    )
    # after submit, defaul result to out
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
  })
  # show previous responses update with current response when submit is clicked
  output$responses <- DT::renderDataTable({
    input$submit
    loadData()
  })
  # display likelihood data table
  output$likeli <- DT::renderDataTable(
    l,
    filter = "top"
  )
}

# run the app
shinyApp(ui = ui, server = server)