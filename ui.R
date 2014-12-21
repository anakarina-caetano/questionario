library(shiny)
# https://github.com/AnalytixWare/ShinySky
library(shinysky)

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
  tags$hr(),
  h4('Curso R - do casual ao avançado'),
  tags$hr(),
  fluidRow(column(4, textInput('nome', 'Nome completo', value='')),
           column(4, textInput('email', 'Email'), value=''),
           column(4, radioButtons('genero', 'Gênero', choices=c('Feminino', 'Masculino', 'Outro'), 
                                  inline=TRUE, selected=NA))),
  
  h4('Parte 01 - Experiência prévia'),
  wellPanel(fluidRow(
    
    radioButtons('q1a', 'a) Você já conhece o R?', c('Sim'='sim', 'Não'='nao'), selected=NA),
    
    conditionalPanel("input.q1a=='sim'",
                     radioButtons('q1a1', 'a.1) Você se considera em que nível de R?',
                                  c('Básico', 'Intermediário', 'Avançado'), selected=NA),
                     checkboxGroupInput('q1a2', 'a.2) Para quê / onde vc usa o R atualmente?', 
                                   c('Uso na faculdade', 'Uso no trabalho', 'Uso pessoal', 'Não uso')),
                     radioButtons('q1a3', 'a.3) Você sabe usar as funcoes vetorizadas do R, como apply, sapply, lapply?', 
                                  c('Sim', 'Não', 'Conheço mas não entendo direito'), selected=NA)
                     ),
    
    tags$br(),
    
    checkboxGroupInput('q1b', 'b) Quais dessas linguagens de programação você saberia utilizar?', 
                       c('C/ C++', 'Java', 'Octave', 'Python', 'Ruby', 'Javascript', 'Matlab', 'Outro', 'Nenhuma'), 
                       inline=T),
    
    tags$br(),
    
    radioButtons('q1c', 'c) Possui conhecimentos prévios em estatística?', 
                 c('Sim, já estudei e sei aplicar modelos de regressão, análise multivariada, machine learning, etc'='sim1',
                   'Sim, já fiz cursos de estatística básica envolvendo inferência e testes de hipóteses'='sim2',
                   'Não conheço muito bem mas sei alguns aspectos básicos de probabilidade e estatística'='nao1',
                   'Não possuo nenhum conhecimento prévio'='nao2'), selected=NA),
    
    tags$br(),
    
    checkboxGroupInput('q1d', 'd) Quais desses softwares você saberia utilizar?', 
                       c('SAS', 'SPSS', 'Stata', 'Minitab', 'S+', 'Outro', 'Nenhuma'), 
                       inline=T)
    
  )), 
    
  h4('Parte 02 - Trabalho'),
  wellPanel(fluidRow(
    
    radioButtons('q2a', 'a) Você trabalha?', c('Sim'='sim', 'Não'='nao'), selected=NA),
    
    conditionalPanel("input.q2a=='sim'",
                     textInput('area', 'a.1) Em que área?'),
                     tags$br(),
                     tags$span('a.2) O que você faz no seu trabalho? Descreva de forma sucinta'), 
                     tags$br(), tags$br(),
                     inputTextarea('q2a2', nrows=5, ncols=60)
    ),
    tags$br()
  )), 
  
  h4('Parte 03 - Em relação ao curso'),
  wellPanel(fluidRow(
    
    checkboxGroupInput('q3a', 'a) Quais são seus objetivos com esse curso?', 
                       c('Quero aprender como o R funciona internamente e quais são os fundamentos por trás da linguagem', 
                         'Quero conhecer melhor a ideia por trás dos novos pacotes que aparecem na ementa do curso', 
                         'Preciso usar R na vida acadêmica, e por isso o curso pode ser útil', 
                         'Preciso usar R no trabalho, e por isso o curso pode ser útil', 
                         'Quero aprender por diversão e entretenimento, e essa parece uma boa oportunidade', 
                         'Tenho projetos pessoais que podem envolver o R, e por isso gostaria de conhecer mais', 
                         'Outros (se quiser espeficique na parte 04)', 
                         'Não possuo objetivos em relação a esse curso...')),
        
    tags$br(),
    
    sliderInput('q3b', 'b) Quantas horas por semana, em média, você pretende dedicar ao curso fora das aulas?', 
                min=0, max=10, value=2, step=1),
    
    tags$br(),
    
    radioButtons('q3c', 'c) Você pretende levar notebook nas aulas (sem contar os laboratórios)?',
                 c('Sim'='sim', 'Não'='nao'), selected=NA),
        
    tags$br()
  )), 
  
  h4('Parte 04 - Dúvidas ou sugestões sobre o curso ou sobre alguma outra coisa'),
  wellPanel(fluidRow(
    
    tags$span('a) Por favor, deixe seu feedback'), tags$br(),
    inputTextarea('q4a', nrows=5, ncols=60)
    
  )),
  
  actionButton('salvar', 'Salvar!'),
  tags$br(), tags$br(),
  shinyalert('salvou', click.hide=FALSE),
  
  tags$br(),
  tags$span('Esse questionário foi feito utilizando R e Shiny. Código disponível em', 
            tags$a('https://github.com/curso-r/questionario', 
                   href='https://github.com/curso-r/questionario', 
                   target='blank')),
  tags$hr()
)
