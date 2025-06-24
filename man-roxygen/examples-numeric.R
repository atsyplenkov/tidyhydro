#' @examples
#' library(tidyhydro)
#' data(avacha)
#'
#' # Supply truth and predictions as bare column names
#' <%=fn %>(avacha, obs, sim)
#'
#' # Or as numeric vectors
#' <%=fn %>_vec(avacha$obs, avacha$sim)
