#' Nash-Sutcliffe efficiency (NSE)
#'
#' @description
#' Calculate the Nash-Sutcliffe efficiency (Nash & Sutcliffe, 1970).
#' Dimensionless (from \eqn{-\infty} to 1). `nse()` indicates how well the plot of observed
#' versus simulated data fits the 1:1 line.
#'
#' @details
#' The Nash-Sutcliffe efficiency is a normalized statistic that determines
#' the relative magnitude of the residual variance (“noise”) compared to the
#' measured data variance (“information”; Nash and Sutcliffe, 1970). According
#' to Moriasi et al. (2015) the metric interpretation can be as follows:
#'
#' - **Excellent**/**Very Good** -- `nse()` > 0.8
#' - **Good** -- 0.6 <= `nse()` <= 0.8
#' - **Satisfactory** -- 0.5 < `nse()` < 0.6
#' - **Poor** -- `nse()` <= 0.5
#'
#' @family numeric metrics
#' @family accuracy metrics
#' @templateVar fn nse
#' @template return
#'
#' @param data A `data.frame` containing the columns specified by the `truth`
#' and `estimate` arguments.
#'
#' @param truth The column identifier for the true results
#' (that is `numeric`). This should be an unquoted column name although
#' this argument is passed by expression and supports
#' [quasiquotation][rlang::quasiquotation] (you can unquote column
#' names). For `_vec()` functions, a `numeric` vector.
#'
#' @param estimate The column identifier for the predicted
#' results (that is also `numeric`). As with `truth` this can be
#' specified different ways but the primary method is to use an
#' unquoted variable name. For `_vec()` functions, a `numeric` vector.
#'
#' @param na_rm A `logical` value indicating whether `NA`
#' values should be stripped before the computation proceeds.
#'
#' @param performance The optional column, indicating should the `nse()` return
#' metric interpretation. See details.
#'
#' @param ... Not currently used.
#'
#' @references
#' Nash, J. E., & Sutcliffe, J. V. (1970). River flow forecasting through
#'  conceptual models part I — A discussion of principles. Journal of Hydrology,
#'  10(3), 282–290. \url{https://doi.org/10.1016/0022-1694(70)90255-6}
#'
#' Moriasi, D. N., Gitau, M. W., Pai, N., & Daggupati, P. (2015). Hydrologic
#'  and Water Quality Models: Performance Measures and Evaluation Criteria.
#'  Transactions of the ASABE, 58(6), 1763–1785.
#'  \url{https://doi.org/10.13031/trans.58.10715}
#'
#' @author Anatolii Tsyplenkov
#'
#' @template examples-numeric
#'
#' @export
#'
nse <- function(data, ...) {
  UseMethod("nse")
}

nse <- yardstick::new_numeric_metric(
  nse,
  direction = "maximize"
)

#' @rdname nse
#' @export
nse.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  performance = FALSE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "nse",
    fn = nse_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm,
    fn_options = list(performance = performance)
  )
}

#' @rdname nse
#' @export
nse_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  performance = FALSE,
  ...
) {
  yardstick::check_numeric_metric(truth, estimate, case_weights = NULL)

  nse_cpp(truth, estimate, na_rm = na_rm, performance = performance)
}
