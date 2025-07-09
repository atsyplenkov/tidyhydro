# File is named with `aaa-` so that it is loaded before any other files. We need
# to call `new_*_metric()` internally from outside any function in the package,
# so this file has to be sourced first. It is a bit of a hack, but works.
# Modified after https://github.com/tidymodels/yardstick/blob/main/R/aaa-new.R

# ------------------------------------------------------------------------------

#' Construct a new measure function
#' @keywords summary_stats
#'
#' @description
#' These functions provide convenient wrappers to create the three types of
#' measure functions in `tidyhydro`: measures of central tendency, variability
#' and symmetry. They add a measure-specific class to `fn` and
#' mimic a behaviour of [yardstick::metric_set()]. These features are used
#' by [measure_set()].
#'
#' See [Custom performance
#' metrics](https://www.tidymodels.org/learn/develop/metrics/) for more
#' information about creating custom metrics.
#'
#' @param fn A function. The measure function to attach a measure-specific class
#'
#' @name new-measure
NULL

#' @rdname new-measure
#' @export
new_tendency_measure <- function(fn) {
  new_measure(fn, class = "tendency_measure")
}

#' @rdname new-measure
#' @export
new_var_measure <- function(fn) {
  new_measure(fn, class = "var_measure")
}

#' @rdname new-measure
#' @export
new_sym_measure <- function(fn) {
  new_measure(fn, class = "sym_measure")
}

#' @include import-standalone-types-check.R
new_measure <- function(fn, direction, class = NULL, call = caller_env()) {
  check_function(fn, call = call)

  class <- c(class, "measure", "function")

  structure(fn, class = class)
}

is_measure <- function(x) {
  inherits(x, "measure")
}

#' @noRd
#' @export
print.measure <- function(x, ...) {
  cat(format(x), sep = "\n")
  invisible(x)
}

#' @noRd
#' @export
format.measure <- function(x, ...) {
  first_class <- class(x)[[1]]
  measure_type <-
    switch(
      first_class,
      "tendency_measure" = "Measure of Central Tendency",
      "var_measure" = "Measure of Variability",
      "sym_measure" = "Measure of Distribution Symmetry",
      "measure"
    )

  cli::cli_format_method(
    cli::cli_text(c("A {measure_type}"))
  )
}
