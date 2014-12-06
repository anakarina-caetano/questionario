library(shiny)
# https://github.com/AnalytixWare/ShinySky
library(shinysky)
library(RMySQL)

inputTextarea <- function(inputId, value="", nrows, ncols) {
  tagList(
    singleton(tags$head(tags$script(src = "textarea.js"))),
    tags$textarea(id = inputId,
                  class = "inputtextarea",
                  rows = nrows,
                  cols = ncols,
                  as.character(value))
  )
}

fluidPage(
  
  h2("Questionário"),
  h4('Curso R - do casual ao avançado'),
  fluidRow(column(4, textInput('nome', 'Nome completo')),
           column(4, textInput('email', 'Email')),
           column(4, radioButtons('genero', 'Gênero', choices=c('Feminino', 'Masculino', 'Outro'), inline=TRUE))),
    
  h4('Questão 01 - experiências anteriores'),
  wellPanel(fluidRow(
    tags$span('Fale um pouco sobre você...'), tags$br(),
    inputTextarea('fale', nrows=5, ncols=60)
  )), 
  
  actionButton('salvar', 'Salvar!'),
  
  tags$br(), tags$br(),
  
  shinyalert('salvou', click.hide=FALSE)

)
