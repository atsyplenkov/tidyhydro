# TODO:
# Add tests
# Add description

#' Geometric Mean (GM)
#' @keywords summary_stats
#'
#' @family descriptive statistics
#' @templateVar fn gm
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
#' @param na_rm A `logical` value indicating whether `NA`
#' values should be stripped before the computation proceeds.
#'
#' @param ... Not currently used.
#'
#' @template examples-description
#'
#' @export
#'

gm <- function(data, ...) {
  UseMethod("gm")
}

gm <- new_tendency_measure(gm)

#' @rdname gm
#' @export
gm.data.frame <- function(
  data,
  truth,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "gm",
    fn = gm_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(truth),
    na_rm = na_rm
  )
}

#' @rdname gm
#' @export
gm_vec <- function(
  truth,
  na_rm = TRUE,
  ...
) {
  checkmate::assert_numeric(
    truth,
    lower = 1e-323
  )
  exp(mean(log(truth), na.rm = na_rm))
}
