library(shiny)
library(shinysky)
library(dplyr)
library(stringr)
library(lubridate)
library(RMySQL)

shinyServer(function(input, output, session) {
  
  valida <- reactive({
    if(!is.null(input$q1a) & 
         !is.null(input$q1c) & 
         !is.null(input$q2a) & 
         !is.null(input$q3a) & 
         !is.null(input$q3c)) {
      
      val <- str_length(input$email) > 0 & 
        str_detect(input$email, fixed('@')) &
        input$q1a %in% c('sim', 'nao') &
        input$q1c %in% c('sim1', 'nao1', 'sim2', 'nao2') &
        input$q2a %in% c('sim', 'nao') &
        length(input$q3a) > 0 & 
        input$q3c %in% c('sim', 'nao')
      
      return(val)
    } else {
      return(0)
    }
  })
  
  dados <- reactive({
    d <- data_frame(datetime=as.character(now()),
               nome=input$nome,
               email=input$email,
               genero=ifelse(is.null(input$genero), '', input$genero),
               q1a=input$q1a,
               q1a1=ifelse(is.null(input$q1a1), '', input$q1a1),
               q1a2=ifelse(is.null(input$q1a2), '', paste0(input$q1a2, collapse='@')),
               q1a3=ifelse(is.null(input$q1a3), '', input$q1a3),
               q1b=ifelse(is.null(input$q1b), '', paste0(input$q1b, collapse='@')),
               q1c=input$q1c,
               q1d=ifelse(is.null(input$q1d), '', paste0(input$q1d, collapse='@')),
               q2a=input$q2a,
               q2a1=ifelse(is.null(input$q2a1), '', input$q2a1),
               q2a2=input$q2a2,
               q3a=ifelse(is.null(input$q3a), '', paste0(input$q3a, collapse='@')),
               q3b=input$q3b,
               q3c=input$q3c,
               q4a=input$q4a) %>%
      as.data.frame()
    return(d)
  })
    
  salva <- reactive({
    res <- FALSE
    try({
      con <- dbConnect("MySQL", host=host, dbname=dbname, username=username, password=password)
      # tabela_atual <- dbReadTable(con, 'questionario')
      d <- dados()
      
      if(dbExistsTable(con, 'questionario')) {
        res <- dbWriteTable(con, 'questionario', d, append=T, row.names=F, overwrite=F)
      } else {
        res <- dbWriteTable(con, 'questionario', d, row.names=F)
      }
      
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
        showshinyalert(session,'salvou', 'Existem campos obrigatórios que não foram preenchidos corretamente', 'danger')
      } else if(!res) {
        showshinyalert(session,'salvou', 'Ocorreu um erro na base de dados.', 'danger')
      }
      
    })
  })
  
})
