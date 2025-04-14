Shiny User Management App
This is a Shiny application built with R that allows multiple users to input their information and displays it in a shared datatable across all sessions. The app includes functionality to send messages to selected users and terminate their sessions.
Features

User Inputs:
Text input for username
Dropdown menu for selecting a job (Engineer, Teacher, Doctor)
Date picker for selecting a date


Datatable:
Displays all active users' session IDs and their inputs
Updates in real-time as users modify their inputs
Removes users from the table when their session ends


Admin Actions:
Send a message to selected users, which appears in the center of their screen
End sessions for selected users


Responsive UI:
Sidebar for inputs
Main panel with datatable and action buttons



Prerequisites
To run this application, you need the following R packages installed:

shiny
DT
dplyr
later (for message auto-clear functionality)

Install them using:
install.packages(c("shiny", "DT", "dplyr", "later"))

Installation

Clone this repository to your local machine:git clone https://github.com/your-username/your-repo-name.git


Navigate to the project directory:cd your



