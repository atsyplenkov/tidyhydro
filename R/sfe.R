#' Standard Factorial Error (SFE)
#'
#' @description
#' Prediction standard factorial error estimated
#' using standard regression methods (see *Herschy, 1978*).
#'
#' @details
#' The metric is widely used for assessing Sediment Rating Curves
#' (e.g., Hicks et al. 2020). The model is usually considered 'unacceptable'
#' if the \eqn{SFE > 2}, see Hicks et al. (2011). It is estimated as follows:
#' \deqn{SFE = \exp\left(\sqrt{\frac{1}{n} \sum_{i=1}^{n}
#' \left( \log\left(\frac{obs_i}{sim_i} \right) \right)^2 }\right)}
#' where:
#' \itemize{
#'   \item \eqn{sim} defines model simulations at time step \eqn{i}
#'   \item \eqn{obs} defines model observations at time step \eqn{i}
#' }
#'
#' @family numeric metrics
#' @family accuracy metrics
#' @templateVar fn sfe
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
#' Herschy, R.W. 1978: Accuracy. Chapter 10 In: Herschy, R.W. (ed.)
#'  Hydrometry - principles and practices. John Wiley and Sons, Chichester,
#'  511 p.
#'
#' Hicks, D. M., Shankar, U., McKerchar, A. I., Basher, L., Lynn, I.,
#'  Page, M., & Jessen, M. (2011). Suspended Sediment Yields from New Zealand
#'  Rivers. Journal of Hydrology (New Zealand), 50(1), 81–142.
#'  \url{https://doi.org/10.3316/informit.315190637227597}
#'
#' Hicks, M., Doyle, M., Watson, J., Holwerda, N., Lynch, B., Wyatt, J.,
#'  Jones, H., & Hill, R. (2020). Measurement of Fluvial Suspended Sediment
#'  Load and its Composition (No. 1.0.0; National Environmental Monitoring
#'  Standards, p. 138).
#'  \url{https://www.nems.org.nz/documents/suspended-sediment}
#'
#' @template examples-numeric
#'
#' @export
#'
sfe <- function(data, ...) {
  UseMethod("sfe")
}

sfe <- yardstick::new_numeric_metric(
  sfe,
  direction = "minimize"
)

#' @rdname sfe
#' @export
sfe.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "sfe",
    fn = sfe_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname sfe
#' @export
sfe_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::check_numeric_metric(truth, estimate, case_weights = NULL)

  sfe_cpp(truth, estimate, na_rm = na_rm)
}
