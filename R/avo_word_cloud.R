
avo_word_cloudUI <- function(id){
  ns <- NS(id)

  tagList(
      column(12,
             plotOutput(ns('wordcloud'))
             )

  )
}







output$plot <- renderPlot({



  v <- terms()
  wordcloud_rep(names(v), v, scale=c(4,0.5),
                min.freq = input$freq, max.words=input$max,
                colors=brewer.pal(8, "Dark2"))
})
