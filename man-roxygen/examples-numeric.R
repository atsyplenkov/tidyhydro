#' @examples
#' library(yardstick)
#' data(solubility_test)
#'
#' # Supply truth and predictions as bare column names
#' <%=fn %>(solubility_test, solubility, prediction)
#'
#' # Or as numeric vectors
#' <%=fn %>_vec(solubility_test$solubility, solubility_test$prediction)
