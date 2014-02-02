library(shiny)

load("states_cases.Rda")
diseases <- unique(as.character(states_cases$disease))
states <- unique(as.character(states_cases$state))

shinyServer(function(input, output) {

    output$diseaseSelect <- renderUI({
        selectInput("disease", "Disease", diseases)
    })

    output$textDisplay <- renderText({
        paste0("You selected ", input$disease)
    })
}
)
