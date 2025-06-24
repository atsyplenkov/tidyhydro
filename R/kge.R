#' Kling-Gupta Efficiency (KGE)
#'
#' @description
#' Calculate the Kling-Gupta Efficiency (Gupta et al., 2009).
#' Dimensionless (from \eqn{-\infty} to 1). `kge()` assesses the accuracy of 
#' simulated data by considering correlation, bias, and variability relative 
#' to observed data.
#'
#' @details
#' The Kling-Gupta Efficiency is a composite metric that decomposes model
#' performance into three components: correlation (r), variability error (α),
#' and bias error (β).
#' It improves upon the Nash-Sutcliffe Efficiency (see [nse])
#' by explicitly accounting for each source of error (Gupta et al., 2009).
#'
#' The Kling-Gupta Efficiency is estimated as follows:
#' \deqn{
#' KGE = 1 - \sqrt{(r - 1)^2 + (\alpha - 1)^2 + (\beta - 1)^2}
#' }
#' where:
#' \itemize{
#'   \item \eqn{r} is the linear Pearson correlation coefficient between
#'   observed and simulated values
#'   \item \eqn{\alpha = \sigma_{sim} / \sigma_{obs}} is the ratio of the
#'   standard deviations (variability error)
#'   \item \eqn{\beta = \mu_{sim} / \mu_{obs}} is the ratio of the
#'   means (bias error)
#' }
#'
#' @note
#' Unlike the Nash–Sutcliffe Efficiency ([nse]), the KGE does not have an
#' inherent benchmark such as "mean flow", and \eqn{KGE = 0} does not
#' correspond to a baseline performance.
#' Therefore, KGE values should not be interpreted as “good” or “bad” based
#' solely on their sign or magnitude.
#' Instead, users are encouraged to examine the individual components (r, α, β)
#' to understand the nature of model performance and consider defining
#' explicit benchmarks based on the study context.
#'
#' For further discussion, see Knoben et al. (2019), who caution against
#' directly translating NSE-based interpretation thresholds to KGE.
#'
#' @family numeric metrics
#' @family accuracy metrics
#' @templateVar fn kge
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
#' Gupta, H.V.; Kling, H.; Yilmaz, K.K.; Martinez, G.F. (2009).
#'  Decomposition of the mean squared error and kge performance criteria:
#'  Implications for improving hydrological modelling. Journal of Hydrology,
#'  377(1-2), 80-91. \url{https://doi.org/10.1016/j.jhydrol.2009.08.003}
#'
#' Knoben, W. J. M., Freer, J. E., & Woods, R. A. (2019).
#'  Technical note: Inherent benchmark or not? Comparing Nash–Sutcliffe and
#'  Kling–Gupta efficiency scores. Hydrology and Earth System Sciences, 23,
#'  4323–4331. \url{https://doi.org/10.5194/hess-23-4323-2019}
#'
#' @template examples-numeric
#'
#' @export
#'
kge <- function(data, ...) {
  UseMethod("kge")
}

kge <- yardstick::new_numeric_metric(
  kge,
  direction = "maximize"
)

#' @rdname kge
#' @export
kge.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "kge",
    fn = kge_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname kge
#' @export
kge_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::check_numeric_metric(truth, estimate, case_weights = NULL)

  kge_cpp(truth, estimate, na_rm = na_rm)
}
