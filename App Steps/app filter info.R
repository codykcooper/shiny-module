
rm(list = ls())
library(ShinyAvacado)
library(shinydashboard)
source("R/filter_controls.R")
# Define UI for application that draws a histogram
ui <- dashboardPage(

    dashboardHeader(title = "ShinyAvacado"),

    dashboardSidebar(
        sidebarMenu(
            filter_controlsUI('filter_controls'),
            menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
            menuItem("Data Vizualization", tabName = "dataviz", icon = icon("bar-chart-o")),
            menuItem("Explore Data", tabName = "eda", icon = icon("cog"))
        )
    ),

    dashboardBody(
        tabItems(
            tabItem(tabName = "overview",
                    DT::dataTableOutput("avo_table")
            ),
            tabItem(tabName = "dataviz",
                    h2("Widgets tab content")
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    con = dbConnect(RSQLite::SQLite(), "Data/avocado.sqlite")

    AppInfo <- reactiveValues(
        df = NULL,
        con = con,
        session_info = list()
    )

    callModule(filter_controls, "filter_controls", AppInfo = AppInfo)

    output$avo_table <- DT::renderDataTable({
        AppInfo$df %>%
        DT::datatable()
    })

    onStop(function(){
        dbDisconnect(con)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
