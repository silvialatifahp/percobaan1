library(shiny)
library(shinydashboard)
library(cluster)
library(dplyr)
library(ggplot2)

shinyServer(
  function(input, output, session) {
    df_raw <- reactive({
      req(input$path_df_raw)
      read_excel(input$path_df_raw$datapath)
    }) #input file
    
    output$df_raw <- DT::renderDataTable({
      datatable(df_raw(),
                options = list(scrollx = TRUE)
      )
    }) #tampilkan datatable
    
    observe({
      updateSelectInput(
        session = session,
        inputId = "var1",
        choices = colnames(df_raw())
      )
      
      updateSelectInput(
        session = session,
        inputId = "var2",
        choices = colnames(df_raw())
      )
    }) #variabel x dan y
    
    res_clusters <- eventReactive(input$analyse, {
      req(
        df_raw(),
        input$var1, input$var2,
        input$n_clusters
         )
      
     res_kmeans <- kmeans(df_raw()[, c(input$var1, input$var2),
                                      drop=FALSE], centers=input$n_clusters
                          )
     cbind(df_raw()[, c(input$var1, input$var2), drop=FALSE],
           Klaster = as.character(res_kmeans$cluster)
           )
    })
    
    plot_kmeans <- reactive({
      req(res_clusters())
      ggplot(
        res_clusters(),
        aes_string(x = input$var1, y = input$var2, colour = "Klaster")
      ) +
        geom_point() +
        scale_colour_manual(values = c(
          "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"
        )) +
        theme_light()
        })
    output$plot_kmeans <- renderPlot({
      plot_kmeans()
    })
    output$df_kmeans <- DT::renderDataTable({
      req(res_clusters())
      datatable(res_clusters()[order(res_clusters()$Klaster),],
                rownames = FALSE)
    })
    
    output$download_plot <- downloadHandler (
      filename = "plot_kmeans.png", content = function(file) {
      ggsave(file, plot_kmeans())
      }, contentType = "image/png")
  }
)
