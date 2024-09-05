#' Lista todas as decisóes da Corte de IDH
#'
#' @return Tibble com título e url para acesso ao pdf
#' @export
#'
corteidh_listar_sentencas <- function(){

url1 <- "https://www.corteidh.or.cr/get_jurisprudencia_search_tipo.cfm"

body <-list(nId_estado_NUM = "T", Texto_busqueda_TXT = "", page_rows = "3000",
lang = "es", nId_Tipo_Jurisprudencia = "CC")

resposta <- url1 |>
httr2::request() |>
httr2::req_body_form(!!!body) |>
httr2::req_perform() |>
httr2::resp_body_html() |>
     xml2::xml_find_all("//li")

titulos <- resposta |>
       purrr::map(~{
         .x |>
            xml2::xml_find_all(".//div[@class='col-12']") |>
            xml2::xml_text()

       }) |>
  purrr::map_if(rlang::is_empty, \(x)NA_character_) |>
  unlist()


urls <- resposta |>
  purrr::map(~{
    .x |>
      xml2::xml_find_all('.//div//a[1]') |>
      xml2::xml_attr("href") |>
      stringr::str_subset("(?i)seriec") |>
      stringr::str_subset("pdf") |>
      purrr::pluck(1)

  }) |>
  purrr::map_if(rlang::is_empty, \(x)NA_character_) |>
  unlist()


tibble::tibble(titulo = titulos, url = urls)

}
