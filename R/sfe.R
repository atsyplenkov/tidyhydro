#' Standard Factorial Error (SFE)
#'
#' @description
#' Prediction standard factorial error estimated
#' using standard regression methods (see *Herschy, 1978*).
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
#' @author Anatolii Tsyplenkov
#'
#' @references
#' Herschy, R.W. 1978: Accuracy. Chapter 10 In: Herschy, R.W. (ed.)
#' Hydrometry - principles and practices. John Wiley and Sons, Chichester,
#' 511 p.
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
