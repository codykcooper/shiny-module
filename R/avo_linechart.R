#' data_overview
#' @export
avo_linechartUI <- function(id){
  ns <- NS(id)

  tagList(
    fluidPage(
      fluidRow(
        fluidRow(
          column(6,
                 pickerInput(ns('region'), label = "Select Region(s)", choices = NULL, multiple = T)
          ),
          column(6,
                 pickerInput(ns('type'), label = 'Avocado Type', choices = c('organic', 'conventional'))
          )
        ),
        fluidRow(
          column(12,
                 plotlyOutput(ns('line_graphs'))
          )
        )
      )
    )

  )
}

#' @export
avo_linechart <- function(input, output, session, AppInfo, grouping_info){

  observe({
    req(AppInfo$df)
    unq_regions = AppInfo$df$region %>% unique()

    States = intersect(state.name %>% gsub(' ','',.), unq_regions)
    Regional = c(
      grep('east|west', setdiff(unq_regions, States), value = T, ignore.case = T),
      'Midsouth','GreatLakes','Plains','SouthCentral')
    Total = 'TotalUS'
    City = setdiff(unq_regions, c(States,Regional,Total))

    choice_list = list(
      Total = Total,
      States = States,
      Region = Regional,
      Cities = City
    )

    updateSelectInput(session = session, inputId = "region", label = "Select Region(s)",
                      selected = input$region, choices = choice_list)
  })

  get_line_data <- reactive({
    req(input$region)
    select_region = input$region
    select_type = input$type

    lin_dat = AppInfo$df %>%
      filter(region %in% select_region & type %in% select_type)

    return(lin_dat)
  })

  plot_data <- reactive({
    get_line_data() %>%
      group_by(region,Date) %>%
      plot_ly(x = ~Date, y = ~Total.Bags,
              type="scatter",color = ~region, mode = "line")
  })

  output$line_graphs <- renderPlotly({
    plot_data()
  })

}

