
rm(list = ls())
library(ShinyAvacado)
library(shinydashboard)
library(plotly)
library(shinyWidgets)
source("R/avo_filter.R")
source("R/avo_linechart.R")
source("R/avo_overview.R")
source("R/avo_explore.R")

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
                    tabsetPanel(
                        tabPanel("Conventional", avo_overviewUI("conv")),
                        tabPanel("Organic", avo_overviewUI("organic"))
                    )
            ),
            tabItem(tabName = "dataviz",
                    avo_linechartUI("lineChart")
            ),
            tabItem(tabName = "eda",
                    avo_exploreUI("eda")
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    AppInfo <- reactiveValues(
        df = NULL,
        con = dbConnect(RSQLite::SQLite(), "Data/avocado.sqlite"),
        tbl_name = 'avocado',
        session_info = list()
    )

    #Call Filter Functions
    callModule(avo_filter, "filter_controls", AppInfo = AppInfo)
    #Call Summary Tables
    callModule(avo_overview, "conv", AppInfo, type = "conventional")
    callModule(avo_overview, "organic", AppInfo, type = "organic")
    #Call Line Chart
    callModule(avo_linechart, 'lineChart', AppInfo = AppInfo)
    #Call Explore functions
    callModule(avo_explore, 'eda', AppInfo = AppInfo)

    #Save data for debugging
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
