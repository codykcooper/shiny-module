
#' avo_exploreUI
#' @export
avo_exploreUI <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      fluidRow(
        column(3,
               pickerInput(ns('plot_type'), label = 'Plot Type',choices = c('Scatter'='scatter','Line'='line'), selected = 'scatter')
               ),
        column(3,
               pickerInput(ns('group_by'), label = 'Group by:', choices = NULL)
               ),
        column(3,
               pickerInput(ns('xvar'), label = "X variable:", choices = NULL)
               ),
        column(3,
               pickerInput(ns('yvar'), label = "Y variable:", choices = NULL)
               )
      ),
      fluidRow(
        plotlyOutput(ns('plot'))
      )
    )
  )
}

avo_explore <- function(input, output, session, AppInfo){

  observe({
    req(AppInfo$df)

    char_var = AppInfo$df %>%
      select_if(is.character) %>%
      names()

    num_var = AppInfo$df %>%
      select_if(is.numeric) %>%
      names()

    updatePickerInput(session = session, inputId = 'group_by', choices = char_var, selected = input$group_by)
    updatePickerInput(session = session, inputId = 'xvar', choices = num_var, selected = input$xvar)
    updatePickerInput(session = session, inputId = 'yvar', choices = num_var, selected = input$yvar)

  })

  plotData <- reactive({
    req(AppInfo$df, input$yvar, input$xvar, input$group_by)

    df <- AppInfo$df %>%
      filter(region != "TotalUS") %>%
      dplyr::select(input$xvar, input$yvar, input$group_by) %>%
      dplyr::group_by_(input$group_by)

    plot_ly(data = df, x = ~get(input$xvar), y = ~get(input$yvar), color = ~get(input$group_by))%>%
      layout(xaxis = list(title = input$xvar), yaxis = list(title = input$yvar))

  })

  output$plot <- renderPlotly({
    plotData()
  })

}
