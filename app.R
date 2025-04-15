library(shiny)
library(DT)
library(dplyr)
library(shinyjs)

jscode <- 'Shiny.addCustomMessageHandler("testmessage",
                              function(message) {
                                alert(JSON.stringify(message));
                              }
);'

active_sessions <- reactiveValues(sessions = list())

# Shared data frame to store user inputs across sessions
user_data <- reactiveValues(data = data.frame(
  SessionID = character(),
  Username = character(),
  Job = character(),
  Date = character(),
  stringsAsFactors = FALSE
))

ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(text = jscode, functions = c("addCustomMessageHandler")),
  sidebarLayout(
    sidebarPanel(
      textInput("username", "Username"),
      selectInput("job", "Job", choices = c("Engineer", "Teacher", "Doctor")),
      dateInput("date", "Date", value = Sys.Date())
    ),
    mainPanel(
      fluidRow()
      ,br()
      ,fluidRow(
        column(6, textInput("message_text", "Message"
                            , placeholder ='Use this space to 
                            type a message to send to selected sessions')),
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
  
  
  observe({
    # Add the current session to active sessions
    session_id <- session$ns(paste0(session$token))
    active_sessions$sessions[[session_id]] <- session
    
  })
  
  # Reactive values to store current user's inputs and message
  current_user <- reactiveValues(
    username = "",
    job = "",
    date = "",
    message = NULL
  )
  
  # Observe changes to inputs and update current_user
  observe({
    current_user$username <- input$username
    current_user$job <- input$job
    current_user$date <- as.character(input$date)
    
    # Update or add user data
    if (nrow(user_data$data) > 0 && session_id %in% user_data$data$SessionID) {
      user_data$data <- user_data$data %>%
        mutate(
          Username = ifelse(SessionID == session_id, current_user$username, Username),
          Job = ifelse(SessionID == session_id, current_user$job, Job),
          Date = ifelse(SessionID == session_id, current_user$date, Date)
        )
    } else {
      user_data$data <- rbind(
        user_data$data,
        data.frame(
          SessionID = session_id,
          Username = current_user$username,
          Job = current_user$job,
          Date = current_user$date,
          stringsAsFactors = FALSE
        )
      )
    }
  })
  
  # Render the DT table
  output$user_table <- renderDT({
    datatable(
      user_data$data
      # ,selection = 'multiple',
      # options = list(pageLength = 10)
    )
  })
  
  # Remove user from table when session ends
  # onSessionEnded(function() {
  #   user_data$data <- user_data$data %>%
  #     filter(SessionID != session_id)
  # })
  
  # Display received message
  output$message_display <- renderUI({
    if (!is.null(current_user$message)) {
      div(
        style = "position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: #f8d7da; padding: 20px; border: 1px solid #dc3545; border-radius: 5px; z-index: 1000;",
        strong("Message: "), current_user$message
      )
    }
  })
  
  
  observeEvent(input$send_message, {

    if ( any(!is.null( input$user_table_rows_selected ) )) {
   
      if (is.null(input$message_text) | input$message_text == '' ) {
    
        showModal(modalDialog('Please add a message', 'Please type a message before trying to send one.'))
        
      } else {

        if (user_data$data$SessionID[input$user_table_rows_selected] %in% user_data$data$SessionID) {
          
          for (sel_row in input$user_table_rows_selected )  {
          
            session_message <- active_sessions$sessions[[user_data$data$SessionID[sel_row]]]
       
            session_message$sendCustomMessage(type = 'testmessage', message = paste0(input$message_text) )
            
          }
          
        }
      }
    } else {
      
      output$status <- renderText("No session selected.")
      
    }
    
  })
  

  
  observeEvent(input$end_session, {
    # End selected session

    if ( any(!is.null( input$user_table_rows_selected ) )) {
      
      if (user_data$data$SessionID[input$user_table_rows_selected] %in% user_data$data$SessionID) {
        
        for (sel_row in input$user_table_rows_selected )  {
          
          session_to_end <- active_sessions$sessions[[user_data$data$SessionID[sel_row]]]
          
          session$sendCustomMessage(type = "end_session", message = TRUE)
          
          # output$status <- renderText(paste("Session", input$user_table_rows_selected, "ended."))
          
          session_to_end$close()
        }
        
      }
      
    } else {
      
      # output$status <- renderText("No session selected.")
      
    }
    
  })
  
  
  # session$onSessionEnded(function() {
  #   
  #   isolate({
  #     user_data$data$SessionID[[session_id]] <- NULL
  #   })
  #   
  # })
  
  
}

shinyApp(ui, server)
