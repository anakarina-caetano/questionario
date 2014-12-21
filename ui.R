
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
  
  h4('Questão 01 - conhecimento prévio com o R'),
  wellPanel(fluidRow(
    #tags$span('Você já conhece o R?'), tags$br(),
    #inputTextarea('fale', nrows=5, ncols=60)
    
    radioButtons('conhece_r', 'Você já conhece o R?', c('Sim'='sim', 'Não'='nao')),
    
    conditionalPanel("input.conhece_r=='sim'",
                     radioButtons('nivel_r', 'Você se considera em que nível de R?',
                                  c('Básico', 'Intermediário', 'Avançado')),
                     checkboxGroupInput('uso_r', 'Para quê / onde vc usa o R atualmente?', 
                                   c('Uso na faculdade', 'Uso no trabalho', 'Uso pessoal', 'Não uso')),
                     radioButtons('pply_r', 'Você sabe usar as funcoes vetorizadas do R, como apply, sapply, lapply?', 
                                  c('Sim', 'Não', 'Conheço mas não entendo direito'))
                     ),
    tags$br()
  )), 
  

  h4('Questão 02 - Experiência com outras linguagens de programação'),
  wellPanel(fluidRow(
    checkboxGroupInput('outras_linguagens', 'Quais dessas linguagens de programacao vc conhece ou utiliza?', 
                       c('C/ C++', 'Java', 'Octave', 'Python', 'Ruby', 'Javascript', 'Matlab', 'Outro', 'Nenhuma'))
  )), 
  
  h4('Questão 03 - Trabalho'),
  wellPanel(fluidRow(
    
    radioButtons('trabalha', 'Você trabalha?', c('Sim'='sim', 'Não'='nao')),
    
    conditionalPanel("input.trabalha=='sim'",
                     textInput('area', 'Em que área?'),
                     tags$br(),
                     tags$span('O que você faz no seu trabalho?'), tags$br(), tags$br(),
                     inputTextarea('oque_faz', nrows=5, ncols=60)
    ),
    tags$br()
    
  )), 
  
  actionButton('salvar', 'Salvar!'),
  
  tags$br(), tags$br(),
  
  shinyalert('salvou', click.hide=FALSE)

)

# 2) [checkbox] Quais dessas linguagens de programacao vc conhece ou utiliza?
# C/ C++; Java; Octave, Python, Ruby, Javascript; Matlab; Outro; Nenhuma
# 
# 3)  Voce trabalha? S;N
# if q3==S:
#   3.1) Em que área? Livre
# 3.2) O que voce faz no seu trabalho? Livre
# 
# 4) [checkbox] Quais softwares estatisticos voce usa?
# SAS; SPSS; Minitab LIXO; S+, Outro
# 
# 5) [checkbox] Quais são seus objetivos com o curso? 
# Quero aprender fundamentos de R e como ele funciona;
# Quero conhecer melhor a ideia por tras dos pacotes que aparecem na ementa do curso;
# Preciso usar R na vida academica;
# Preciso usar R no trabalho;
# Diversao/ Entretenimento;
# Tenho projetos pessoais que envolvem o R
# 
# 6) [textarea] Comentários adicionais (suas expectativas, informacoes pertinentes, etc)

