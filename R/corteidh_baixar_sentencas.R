#' Baixa decisões da Corte IDH
#'
#' @param urls Vetor de urls
#' @param diretorio Diretório onde armazenar os pdfs
#'
#' @return pdf
#' @export
#'
corteidh_baixar_sentencas <- function(urls, diretorio){

  purrr::walk(urls, purrr::possibly(~{

    arquivo <- file.path(diretorio, basename(.x))

    .x |>
       httr2::request() |>
       httr2::req_perform(path = arquivo)


  }, NULL), .progress = TRUE)


}
