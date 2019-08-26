
#' avo_overviewUI
#' @export
avo_overviewUI <- function(id){
  ns <- NS(id)

  tagList(
    fluidPage(
           DT::dataTableOutput(ns('myTable'))
           )
  )
}

#' avo_overview
#' @export
avo_overview <- function(input, output, session, AppInfo, type = 'organic'){

  get_data <- reactive({
    req(AppInfo$df)

    dfSum <<- AppInfo$df %>%
      filter(type == !!type) %>%
      group_by_if(is.character) %>%
      summarise_if(is.numeric, function(x) round(sum(x), 2))

    return(dfSum)

  })

  output$myTable <- DT::renderDataTable({
    get_data() %>%
      DT::datatable(
        options = list(pageLength = 20),
        filter = list(position = 'top', clear = FALSE)
        )
  })
}
