
rm(list = ls())
library(ShinyAvacado)
library(shinydashboard)
library(plotly)
library(shinyWidgets)
source("R/avo_filter.R")
source("R/avo_linechart.R")

# Define UI for application that draws a histogram
ui <- dashboardPage(

    dashboardHeader(title = "ShinyAvacado"),

    dashboardSidebar(
        sidebarMenu(
            avo_filterUI('filter_controls'),
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
                    avo_linechartUI("lineChart")
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    AppInfo <- reactiveValues(
        df = NULL,
        con = dbConnect(RSQLite::SQLite(), "Data/avocado.sqlite"),
        session_info = list()
    )

    callModule(avo_filter, "filter_controls", AppInfo = AppInfo)

    output$avo_table <- DT::renderDataTable({
        AppInfo$df %>%
        DT::datatable()
    })

    callModule(avo_linechart, 'lineChart', AppInfo = AppInfo)

    observe(
        out_list <<- reactiveValuesToList(AppInfo)
    )

    onStop(function(){
        observe({
            dbDisconnect(AppInfo$con)
        })
    })
}

# Run the application
shinyApp(ui = ui, server = server)
