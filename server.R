library(shiny)
library(shinysky)
library(dplyr)
library(stringr)
library(lubridate)
library(RMySQL)



shinyServer(function(input, output, session) {
  
  valida <- reactive({
    val <- str_length(input$email) > 0 & str_detect(input$email, fixed('@'))
    return(val)
  })
  
  dados <- reactive({
    d <- data.frame(nome=input$nome,
               email=input$email,
               genero=input$genero,
               fale=input$fale)
    return(d)
  })
    
  salva <- reactive({
    res <- FALSE
    try({
      con <- dbConnect("MySQL", host=host, dbname=dbname, username=username, password=password)
      tabela_atual <- dbReadTable(con, 'questionario')
      d <- dados()
      res <- dbWriteTable(con, 'questionario', d, append=T, row.names=F, overwrite=F)
      dbDisconnect(con)
    })
    return(res)
  })
  
  observe({
    aux <- input$salvar
    isolate({
      val <- valida()
      res <- FALSE
      
      if(aux > 0 & val) {
        res <- salva()
      }
      
      if(aux > 0 & val & res) {
        showshinyalert(session,'salvou', 'Salvou!!', 'success')
      } else if (aux == 0) {
        showshinyalert(session, 'salvou', 'Clique em salvar!', 'warning')
      } else if (!val) {
        showshinyalert(session,'salvou', 'Existem campos preenchidos de forma errada :(', 'danger')
      } else if(!res) {
        showshinyalert(session,'salvou', 'Ocorreu um erro na base de dados :(', 'danger')
      }
    })
  })
    
})

