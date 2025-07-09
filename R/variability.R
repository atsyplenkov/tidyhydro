#' Coefficient of Variation (Cv)
#' @keywords summary
#'
#' @family numeric metrics
#' @family accuracy metrics
#' @templateVar fn cv
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

cv <- function(data, ...) {
  UseMethod("cv")
}

cv <- yardstick::new_numeric_metric(
  cv,
  direction = "minimize"
)

#' @rdname cv
#' @export
cv.data.frame <- function(
  data,
  truth,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "cv",
    fn = cv_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(truth),
    na_rm = na_rm
  )
}

#' @rdname cv
#' @export
cv_vec <- function(
  truth,
  na_rm = TRUE,
  ...
) {
  yardstick::check_numeric_metric(truth, truth, case_weights = NULL)

  if (na_rm) {
    truth <- truth[!is.na(truth)]
  }

  x0 <- mean(truth)
  k <- truth / x0

  sqrt(sum((k - 1)^2) / (length(truth) - 1))
}
