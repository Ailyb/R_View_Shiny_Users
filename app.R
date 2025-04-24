library(shiny)
library(DT)
library(dplyr)
library(shinyjs)

jscode <- 'Shiny.addCustomMessageHandler("testmessage",
                              function(message) {
                                alert(JSON.stringify(message));
                              }
);'

# Reactive values for active sessions
active_sessions <- reactiveValues(sessions = list())

# Shared data frame to store user inputs across sessions (initialize empty)
user_data <- reactiveValues(data = data.frame(SessionID = character(), stringsAsFactors = FALSE))

ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(text = jscode, functions = c("addCustomMessageHandler")),
  sidebarLayout(
    sidebarPanel(
      # Example inputs (can be any set of inputs)
      textInput("username", "Username"),
      selectInput("job", "Job", choices = c("Engineer", "Teacher", "Doctor")),
      dateInput("date", "Date", value = Sys.Date()),
      numericInput("age", "Age", value = 30),
      textInput("comment", "Comment") # Added to show flexibility
    ),
    mainPanel(
      fluidRow(),
      br(),
      fluidRow(
        column(6, textInput("message_text", "Message", placeholder = 'Use this space to type a message to send to selected sessions')),
        column(3, actionButton("send_message", "Send Message to Selected")),
        column(3, actionButton("end_session", "End Selected Session(s)"))
      ),
      DTOutput("user_table"),
      uiOutput("message_display")
    )
  )
)

server <- function(input, output, session) {
  # Generate a unique session ID
  session_id <- session$token

  # Add the current session to active sessions
  observe({
    active_sessions$sessions[[session_id]] <- session
  })

  # Reactive values to store current user's message
  current_user <- reactiveValues(message = NULL)

  # Observe all inputs dynamically
  observe({
    # Get all inputs as a named list
    all_inputs <- reactiveValuesToList(input)

    # Exclude non-data inputs (e.g., buttons, message_text)
    excluded_inputs <- c("send_message", "end_session", "message_text", "user_table_rows_selected")
    data_inputs <- all_inputs[!names(all_inputs) %in
