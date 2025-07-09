#' @examples
#' library(tidyhydro)
#' data(avacha)
#'
#' # Supply truth and predictions as bare column names
#' <%=fn %>(avacha, obs)
#'
#' # Or as numeric vectors
#' <%=fn %>_vec(avacha$obs)
