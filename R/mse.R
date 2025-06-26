#' Mean Squared Error (MSE)
#'
#' @description
#' The MSE is a metric that evaluates the goodness of fit between model
#' simulations and observations (*Fisher, 1920*). Measured in the squared
#' units of `truth` and `estimate` and can vary from \eqn{-\infty} to
#' \eqn{+\infty}.
#'
#' @details
#' The MSE is estimated as follows (Clark et al., 2021):
#' \deqn{
#' MSE = \frac{1}{n} \sum_{i=1}^{n}{(sim_i - obs_i)^2}
#' }
#' where:
#' \itemize{
#'   \item \eqn{sim} defines model simulations at time step \eqn{i}
#'   \item \eqn{obs} defines model observations at time step \eqn{i}
#' }
#'
#' @family numeric metrics
#' @family accuracy metrics
#' @templateVar fn mse
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
#' @param ... Not currently used.
#'
#' @references
#' Fisher, R. A. (1920). Accuracy of observation, a mathematical
#'  examination of the methods of determining, by the mean error and
#'  by the mean square error. Monthly Notices of the Royal Astronomical
#'  Society, 80, 758–770. \doi{10.1093/mnras/80.8.758}
#'
#' Clark, M. P., Vogel, R. M., Lamontagne, J. R., Mizukami, N.,
#'  Knoben, W. J. M., Tang, G., Gharari, S., Freer, J. E., Whitfield,
#'  P. H., Shook, K. R., & Papalexiou, S. M. (2021). The Abuse of Popular
#'  Performance Metrics in Hydrologic Modeling. Water Resources Research, 57(9),
#'  e2020WR029001. \doi{10.1029/2020WR029001}
#'
#' @template examples-numeric
#'
#' @export
#'
mse <- function(data, ...) {
  UseMethod("mse")
}

mse <- yardstick::new_numeric_metric(
  mse,
  direction = "minimize"
)

#' @rdname mse
#' @export
mse.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "mse",
    fn = mse_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname mse
#' @export
mse_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::check_numeric_metric(truth, estimate, case_weights = NULL)

  mse_cpp(truth, estimate, na_rm = na_rm)
}
