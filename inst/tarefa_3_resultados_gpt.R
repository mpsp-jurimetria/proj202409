#!/usr/bin/env Rscript

a <- JurisMiner::listar_arquivos("data-raw/gpt")


colunas <- c(
  "resumo",
  "fundamentos",
  "investigacao",
  "devida_diligencia",
  "omissao",
  "verdade",
  "falhas",
  "falhas_verificadas",
  "recomendacoes",
  "obrigacoes",
  "quais_obrigacoes",
  "mp",
  "minessota",
  "vida"
)

gpt <- JurisMiner::gpt_ler(a, colunas)



conn = DBI::dbConnect(odbc::odbc(),Driver='ODBC Driver 18 for SQL Server',Server='mpdbcaexlab-v',Database='jurimetria',UID='jose',PWD=12345,TrustServerCertificate='yes')


projetos::msql_write_table(conn,schema = "proj202409", table = "gpt", gpt)

DBI::dbDisconnect(conn)



resumo_geral <-  gpt |>
  dplyr::pull(resumo) |>
  stringr::str_c(collapse = ";") |>
  JurisMiner::azure_openai_extrair(tipo_texto = "465 resumos de decisões da corte interamericana de direitos  humanos", perguntas = "Faça um amplo resumo geral e único desses resumos destacando
                                   , quando possível, falhas nas investigações por violações perpetradas por agentes do estado, violação do dever devida diligência, responsabilidade do estado por violação de direitos, se houve menção ao Mistério público e recomedações da corte", colunas = "resumo" )


fundamento_geral <-  gpt |>
  dplyr::pull(fundamentos) |>
  stringr::str_c(collapse = ";") |>
  JurisMiner::azure_openai_extrair(tipo_texto = "Longa lista fundamentos articulados pela  corte interamericana de direitos  humanos", perguntas = "Faça um resumo geral amplo  e único dos principais fundamendos articulados pela Corte", coluna = "fundamentos")

recomendacao_geral <-  gpt |>
  dplyr::pull(recomendacoes) |>
  stringr::str_c(collapse = ";") |>
  JurisMiner::azure_openai_extrair(tipo_texto = "Longa lista de recomendações apresentadas pela  corte interamericana de direitos  humanos", perguntas = "Faça um resumo geral amplo  e único das principais recomendações feitas pela Corte", coluna = "recomendacao")


falhas_geral <-  gpt |>
  dplyr::pull(falhas_verificadas) |>
  stringr::str_c(collapse = ";") |>
  JurisMiner::azure_openai_extrair(tipo_texto = "Longa lista de falhas verificadas pela  corte interamericana de direitos  humanos nas investigações realizadas pelos estados", perguntas = "Faça um resumo geral amplo  e único das principais falhas verificadas pela Corte", coluna = "folha")

falhas_geral |>


resumo_investigacao <- gpt |>
         dplyr::filter(investigacao=="sim") |>
         dplyr::pull(resumo) |>
         stringr::str_c(collapse = ";") |>
  JurisMiner::azure_openai_extrair(tipo_texto = "234 resumos de decisões da corte interamericana de direitos  humanos", perguntas = "Faça um resumo dessas decisoes ", colunas = "resumo" )




table(gpt$falhas)



