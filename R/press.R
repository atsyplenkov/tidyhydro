#' PRediction Error Sum of Squares (PRESS)
#' @keywords regression
#'
#' @description
#' \eqn{PRESS} is a measure of the quality of a regression model using
#' residuals. \eqn{PRESS} is a validation-type estimator of error that uses
#' the deleted residuals to provide an estimate of the prediction error.
#' When comparing alternate regression models, selecting the model with the
#' lowest value of the \eqn{PRESS} statistic is a good approach because it
#' means that the equation produces the least error when making new predictions
#' (see *Helsel et al., 2020*).
#'
#' It is particularly valuable in assessing multiple forms of multiple
#' linear regressions, but it is also useful for
#' simply comparing different options for a single explanatory variable in
#' single-variable regression models.
#'
#' @details
#' The \eqn{PRESS} is only relevant for comparisons to other regression models
#' with the same response variable units (*Rasmunsen et al., 2009*).
#'
#' It estimates as follows:
#' \deqn{
#'   PRESS = \sum_{i=1}^{n}{(sim_i - obs_i)^2}
#' }
#'
#' where:
#' \itemize{
#'   \item \eqn{sim} defines model simulations at time step \eqn{i}
#'   \item \eqn{obs} defines model observations at time step \eqn{i}
#' }
#'
#' @note
#' The $PRESS$ statistic is not appropriate for comparison of models having
#' different transformations of response variable, e.g. linear regression and
#' log-transformed linear regression (*Helsel et al., 2020*).
#'
#' @family regression metrics
#' @templateVar fn press
#' @template return
#'
#' @param data A `data.frame` containing the columns specified by the `truth`
#' and `estimate` arguments.
#' @param truth The column identifier for the true results
#' (that is `numeric`). This should be an unquoted column name although
#' this argument is passed by expression and supports
#' [quasiquotation][rlang::quasiquotation] (you can unquote column
#' names). For `_vec()` functions, a `numeric` vector.
#' @param estimate The column identifier for the predicted
#' results (that is also `numeric`). As with `truth` this can be
#' specified different ways but the primary method is to use an
#' unquoted variable name. For `_vec()` functions, a `numeric` vector.
#' @param na_rm A `logical` value indicating whether `NA`
#' values should be stripped before the computation proceeds.
#' @param ... Not currently used.
#'
#' @references
#' Rasmussen, P. P., Gray, J. R., Glysson, G. D. & Ziegler, A. C.
#'  Guidelines and procedures for computing time-series suspended-sediment
#'  concentrations and loads from in-stream turbidity-sensor and streamflow
#'  data. in U.S. Geological Survey Techniques and Methods book 3, chap.
#'  C4 53 (2009) \url{https://pubs.usgs.gov/tm/tm3c4/}.
#'
#' Helsel, D. R., Hirsch, R. M., Ryberg, K. R., Archfield, S. A. &
#'  Gilroy, E. J. Statistical Methods in Water Resources. 484 (2020)
#'  \doi{10.3133/tm4A3}.
#'
#' @template examples-numeric
#'
#' @export
#'
press <- function(data, ...) {
  UseMethod("press")
}

press <- yardstick::new_numeric_metric(
  press,
  direction = "minimize"
)

#' @rdname press
#' @export
press.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "press",
    fn = press_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname press
#' @export
press_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::check_numeric_metric(truth, estimate, case_weights = NULL)

  press_cpp(truth, estimate, na_rm = na_rm)
}
