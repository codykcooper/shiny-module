
#' filter_controlsUI
avo_filterUI <- function(id){
  ns <- NS(id)

  tagList(
    fluidRow(
      dateRangeInput(
        inputId = ns("date"),
        label = "Select Date Range"
        )
    )
  )
}


avo_filter <- function(input, output, session, AppInfo){

  observe({
    req(AppInfo$con)

    date_range = tbl(AppInfo$con, AppInfo$tbl_name) %>%
      summarise(
        date_min = min(Date),
        date_max = max(Date)
      ) %>% collect()

    updateDateRangeInput(
      session = session,
      inputId = "date",
      label = "Select Date Range",
      min = date_range$date_min,
      max = date_range$date_max,
      end = date_range$date_max,
      start = as.Date(date_range$date_max) - 61
    )
  })

  filter_data <- reactive({
    req(input$date)
    dmin <- input$date[1]
    dmax <- input$date[2]

    df_filtered = tbl(AppInfo$con, AppInfo$tbl_name) %>%
      filter(between(Date, dmin, dmax)) %>%
      collect() %>%
      mutate(Date = as.Date(Date)) %>%
      dplyr::arrange(Date)

    return(df_filtered)

  })

  observe({
    AppInfo$df <- filter_data()
  })

}
