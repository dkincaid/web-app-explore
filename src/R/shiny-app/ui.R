library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Tycho Data Exploration"),
    sidebarPanel(
        htmlOutput("diseaseSelect")

        ),

    mainPanel(
        textOutput("textDisplay")
        )
    )
)
