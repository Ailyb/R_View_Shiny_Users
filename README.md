# Shiny User Management App

This is a Shiny application built with R that allows multiple users to input their information and displays it in a shared datatable across all sessions. The app includes functionality to send messages to selected users and terminate their sessions.

## Features

- **User Inputs**:
  - Text input for username
  - Dropdown menu for selecting a job (Engineer, Teacher, Doctor)
  - Date picker for selecting a date
- **Datatable**:
  - Displays all active users' session IDs and their inputs
  - Updates in real-time as users modify their inputs
  - Removes users from the table when their session ends
- **Admin Actions**:
  - Send a message to selected users, which appears in the center of their screen
  - End sessions for selected users
- **Responsive UI**:
  - Sidebar for inputs
  - Main panel with datatable and action buttons

## Prerequisites

To run this application, you need the following R packages installed:

- `shiny`
- `DT`
- `dplyr`
- `later` (for message auto-clear functionality)

Install them using:

```R
install.packages(c("shiny", "DT", "dplyr", "later"))
```

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   ```
2. Navigate to the project directory:
   ```bash
   cd your-repo-name
   ```
3. Ensure you have R and RStudio installed.

## Usage

1. Open the `app.R` file in RStudio.
2. Click the "Run App" button or execute the following command in R:
   ```R
   shiny::runApp()
   ```
3. The app will launch in your default web browser.
4. Enter a username, select a job, and pick a date in the sidebar.
5. View the datatable in the main panel to see all active users.
6. Select one or more users in the dat