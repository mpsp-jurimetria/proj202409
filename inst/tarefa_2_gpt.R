#!/usr/bin/env Rscript



conn = DBI::dbConnect(odbc::odbc(),Driver='ODBC Driver 18 for SQL Server',Server='mpdbcaexlab-v',Database='jurimetria',UID='jose',PWD=12345,TrustServerCertificate='yes')

sentencas <- DBI::dbGetQuery(conn,"select * from proj202409.sentencas") |>
            dplyr::mutate(arquivo = stringr::str_replace(arquivo, "pdf","json"))

DBI::dbDisconnect(conn)

diretorio <- here::here("data-raw/gpt")

perguntas <- c(
  "faça um breve resumo da sentenca da Corte Interamericana de Direitos Humanos que está escrita em espanhol",
  "Quais foram os principais fundamentos da decisão? separe-os por ponto e vírgula",
  "Houve investigação de violências perpetradas pelo Estado/por seus funcionários/policiais? Responda apenas sim ou não",
  "Houve violação do dever de devida diligência? responda apenas sim ou não",
  "Houve referência à obstrução ou omissão às investigações? Responda apenas sim ou não",
  "Houve referência ao direito à verdade? responda sim ou não",
  "Houve referências a falhas na investigação?",
  "Se houve referências a falhas na investigação, quais as falhas verificadas? separe-as por ponto e vírgula",
  "Se houve referências a falhas na investigação, quais as recomendações para correção?",
  "Houve imposição de obrigações ao Estado?, responda apenas sim ou não",
  "Se Houve imposição de obrigações ao Estado, quais as obrigações? separe-as por ponto e vírgula",
  "Houve menção ao Ministério Público, fiscalía, prosecutor ou a menção à investigação por órgão independente daquele do responsável pela violação? responda apenas sim ou não",
  "Houve menção ao Protocolo de Minnesota? responda apenas sim ou não",
  "O Estado é responsável pela violação ao direito à vida, à integridade e à proteção? responda apenas sim ou não"
)

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


purrr::walk2(sentencas$texto,sentencas$arquivo, purrr::possibly(~{

  arquivo <- file.path(diretorio, .y)


    JurisMiner::azure_openai_extrair(.x, perguntas = perguntas, colunas = colunas ) |>
      write(arquivo)

},NULL))
