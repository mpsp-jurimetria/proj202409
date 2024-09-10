#!/usr/bin/env Rscript


df <- proj202409::corteidh_listar_sentencas()


diretorio <- here::here("data-raw/sentencas")

proj202409::corteidh_baixar_sentencas(df$url, diretorio)


conn = DBI::dbConnect(odbc::odbc(),Driver='ODBC Driver 18 for SQL Server',Server='mpdbcaexlab-v',Database='jurimetria',UID='jose',PWD=12345,TrustServerCertificate='yes')


projetos::msql_write_table(conn, schema = "proj202409", table = "lista_sentencas", df)

textos <- JurisMiner::ler_pdfs(diretorio = diretorio)


projetos::msql_write_table(conn, schema = "proj202409", table = "sentencas", textos)


