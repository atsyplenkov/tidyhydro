#' Mean daily water discharge at the Avacha River (Elizovo City)
#' @keywords data
#' 
#' @details These data contain the measured (`obs`) mean daily water discharge
#' values (in \eqn{m^3/s}) at the Avacha River streamgage near Elizovo City, 
#' Russia, 2022 calendar year. They are accompanied by the GloFAS v4.0
#' reanalysis water discharge values for the last 24 hours (`sim`), derived
#' from
#' \url{https://ewds.climate.copernicus.eu/datasets/cems-glofas-historical}.
#'
#' Read more about GloFAS Water Discharge reanalysis --
#' \url{https://confluence.ecmwf.int/display/CEMS/GloFAS+v4.0}
#'
#' @name avacha
#' @aliases avacha
#' @docType data
#' @return \item{avacha}{a data frame}
#'
#' @source
#' * observed water discharge \url{https://gmvo.skniivh.ru/}
#' * simulated water discharge 
#'   \url{https://ewds.climate.copernicus.eu/datasets/cems-glofas-historical}
#'
#' @keywords datasets
#' @examples
#' data(avacha)
#' str(avacha)
NULL
