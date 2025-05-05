# remotes::install_github("surveydown-dev/surveydown", force = TRUE)
library(surveydown)
library(quarto)
library(bslib)
library(shinyWidgets)

# Database setup --------------------------------------------------------------
#
# Details at: https://surveydown.org/manuals/storing-data
#
# surveydown stores data on any PostgreSQL database. We recommend
# https://supabase.com/ for a free and easy to use service.
#
# Once you have your database ready, run the following function to store your
# database configuration parameters in a local .env file:
#
# sd_db_config()
#
# Once your parameters are stored, you are ready to connect to your database.
# For this demo, we set ignore = TRUE in the following code, which will ignore
# the connection settings and won't attempt to connect to the database. This is
# helpful if you don't want to record testing data in the database table while
# doing local testing. Once you're ready to collect survey responses, set
# ignore = FALSE or just delete this argument.


db <- sd_db_connect()

data <- sd_get_data(db)


# Server setup
server <- function(input, output, session) {

  # Define any conditional skip logic here (skip to page if a condition is true)
  sd_skip_if()

  # Define any conditional display logic here (show a question if a condition is true)
  sd_show_if()

  # Database designation and other settings
  sd_server(
    db = db,
    required_questions = c("consent", "participant_id", "test",
                           "promotecare1", "preventharm1", "failcare1",  "failharm1", "escapeharm1", 
                           "promotecare2", "preventharm2", "failcare2",  "failharm2", "escapeharm2", 
                           "promotecare3", "preventharm3", "failcare3",  "failharm3", "escapeharm3",
                           "promotecare4", "preventharm4", "failcare4",  "failharm4", "escapeharm4",
                           "promotecare5", "preventharm5", "failcare5",  "failharm5", "escapeharm5", 
                           "goal1", "goal2", "goal3", "goal4", "goal5", "goal6", "goal7", "goal8",
                           "goal9", "goal10", "gender", "race", "education", "role", "industry", "age",
                           "surveys", "prevent_qual", "promote_qual", "training_date"),
    use_cookies = FALSE, # if cookies are left on it breaks if you want to retake the survey
    auto_scroll = TRUE
  )
  
  output$display_participant_id = renderUI({
    HTML(paste0('<div style="text-align:center;"><b>Participant ID:</b> ', input$participant_id, '</div>'))
  }) # display participant id in bold so they remember their info for the results section
  
  output$display_team_id = renderUI({
    HTML(paste0('<div style="text-align:center;"><b>Team ID:</b> ', input$team_id, '</div>'))
  })
  
  output$display_training_date = renderUI({
    HTML(paste0('<div style="text-align:center;"><b>Training Date:</b> ', input$training_date, '</div>'))
  })


}

# shinyApp() initiates your app - don't change it
shiny::shinyApp(ui = sd_ui(), server = server)
