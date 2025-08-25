#' Kling-Gupta Efficiency (KGE)
#' @keywords gof
#'
#' @description
#' Calculate the Kling-Gupta Efficiency (*Gupta et al., 2009*).
#' Dimensionless (from \eqn{-\infty} to 1). `kge()` assesses the accuracy of
#' simulated data by considering correlation, bias, and variability relative
#' to observed data.
#'
#' @details
#' The Kling-Gupta Efficiency is a composite metric that decomposes model
#' performance into three components: correlation (\eqn{r}),
#' variability ratio (\eqn{\alpha}), and bias ratio (\eqn{\beta}).
#' It improves upon the Nash-Sutcliffe Efficiency (see [nse])
#' by explicitly accounting for each source of error (*Gupta et al., 2009*).
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
#'   standard deviations (variability ratio)
#'   \item \eqn{\beta = \mu_{sim} / \mu_{obs}} is the ratio of the
#'   means (bias ratio)
#' }
#'
#' @note
#' Unlike the Nash–Sutcliffe Efficiency ([nse]), the KGE does not have an
#' inherent benchmark such as "mean flow", and \eqn{KGE = 0} does not
#' correspond to a baseline performance.
#' Therefore, KGE values should not be interpreted as "good" or "bad" based
#' solely on their sign or magnitude.
#' Instead, users are encouraged to examine the individual components
#' (\eqn{r}, \eqn{\alpha}, \eqn{\beta})
#' to understand the nature of model performance and consider defining
#' explicit benchmarks based on the study context.
#'
#' For further discussion, see Knoben et al. (2019), who caution against
#' directly translating NSE-based interpretation thresholds to KGE.
#'
#' @family KGE variants
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
#'  377(1-2), 80-91. \doi{10.1016/j.jhydrol.2009.08.003}
#'
#' Knoben, W. J. M., Freer, J. E., & Woods, R. A. (2019).
#'  Technical note: Inherent benchmark or not? Comparing Nash–Sutcliffe and
#'  Kling–Gupta efficiency scores. Hydrology and Earth System Sciences, 23,
#'  4323–4331. \doi{10.5194/hess-23-4323-2019}
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

  kge_cpp(truth, estimate, na_rm = na_rm, version = "2009")
}

#' Modified Kling-Gupta Efficiency (KGE')
#' @keywords gof
#'
#' @description
#' Calculate the modified Kling-Gupta Efficiency (*Kling et al., 2012*),
#' aka \eqn{KGE'}. Dimensionless (from \eqn{-\infty} to 1).
#' `kge2012()` assesses the accuracy of
#' simulated data by considering correlation, bias, and variability relative
#' to observed data.
#'
#' @details
#' The Modified Kling-Gupta Efficiency is a composite metric that decomposes
#' model performance into three components: correlation (\eqn{r}),
#' bias ratio (\eqn{\beta}), and variability ratio (\eqn{\gamma}).
#' It improves upon the Kling-Gupta Efficiency (see [kge]) by replacing
#' standard deviation with Coefficient of Variation. This ensures that the
#' bias and variability ratios are not cross-correlated,
#' which otherwise may occur when e.g. the precipitation inputs are biased.
#'
#' The Modified Kling-Gupta Efficiency (\eqn{KGE'}) is estimated as follows:
#' \deqn{
#' KGE' = 1 - \sqrt{(r - 1)^2 + (\beta - 1)^2 + (\gamma - 1)^2}
#' }
#' where:
#' \itemize{
#'   \item \eqn{r} is the linear Pearson correlation coefficient between
#'   observed and simulated values
#'   \item \eqn{\beta = \mu_{sim} / \mu_{obs}} is the ratio of the
#'   means (bias ratio)
#'   \item \eqn{
#'         \gamma = \frac{\sigma_{sim} / \mu_{sim}}{\sigma_{sim} / \mu_{sim}}
#'         } is the ratio of the Coefficients of Variation (variability ratio)
#' }
#'
#' @note
#' Unlike the Nash–Sutcliffe Efficiency ([nse]), the KGE does not have an
#' inherent benchmark such as "mean flow", and \eqn{KGE' = 0} does not
#' correspond to a baseline performance.
#' Therefore, \eqn{KGE'} values should not be interpreted as "good" or "bad"
#' based solely on their sign or magnitude.
#' Instead, users are encouraged to examine the individual components
#' (\eqn{r}, \eqn{\beta}, \eqn{\gamma})
#' to understand the nature of model performance and consider defining
#' explicit benchmarks based on the study context.
#'
#' For further discussion, see Knoben et al. (2019), who caution against
#' directly translating NSE-based interpretation thresholds to KGE.
#'
#' @family KGE variants
#' @templateVar fn kge2012
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
#' Kling, H., Fuchs, M., & Paulin, M. (2012). Runoff conditions in the upper
#'  Danube basin under an ensemble of climate change scenarios.
#'  Journal of Hydrology, 424–425, 264–277.
#'  \doi{10.1016/j.jhydrol.2012.01.011}
#'
#' Knoben, W. J. M., Freer, J. E., & Woods, R. A. (2019).
#'  Technical note: Inherent benchmark or not? Comparing Nash–Sutcliffe and
#'  Kling–Gupta efficiency scores. Hydrology and Earth System Sciences, 23,
#'  4323–4331. \doi{10.5194/hess-23-4323-2019}
#'
#' @template examples-numeric
#'
#' @export
#'
kge2012 <- function(data, ...) {
  UseMethod("kge2012")
}

kge2012 <- yardstick::new_numeric_metric(
  kge2012,
  direction = "maximize"
)

#' @rdname kge2012
#' @export
kge2012.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "kge2012",
    fn = kge2012_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname kge2012
#' @export
kge2012_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::check_numeric_metric(truth, estimate, case_weights = NULL)

  kge_cpp(truth, estimate, na_rm = na_rm, version = "2012")
}


#' Log-transformed Modified Kling-Gupta Efficiency
#' @rdname kgelog
#' @keywords gof
#'
#' @description
#' Calculate the modified Kling-Gupta Efficiency (*Kling et al., 2012*),
#' aka \eqn{KGE'}. Dimensionless (from \eqn{-\infty} to 1).
#' `kge2012()` assesses the accuracy of
#' simulated data by considering correlation, bias, and variability relative
#' to observed data.
#'
#' @family KGE variants
#' @templateVar fn kgelog
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
#' @param ... Not currently used.
#' 
#' @templateVar fn kgelog
#' @template examples-numeric
#'
#' @export
#'
kgelog <- function(data, ...) {
  UseMethod("kgelog")
}

kgelog <- yardstick::new_numeric_metric(
  kgelog,
  direction = "maximize"
)

#' @rdname kgelog
#' @export
kgelog.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "kgelog",
    fn = kgelog_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname kgelog
#' @export
kgelog_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  # checks
  checkmate::assert_numeric(
    truth,
    lower = 1e-323
  )
  checkmate::assert_numeric(
    estimate,
    lower = 1e-323
  )

  # Log-transform
  truth_log <- log10(truth)
  estimate_log <- log10(estimate)

  # More checks
  yardstick::check_numeric_metric(
    truth_log,
    estimate_log,
    case_weights = NULL
  )

  kge_cpp(truth_log, estimate_log, na_rm = na_rm, version = "2012")
}

#' @rdname kgelog
#' @export
kgelog_low <- function(data, ...) {
  UseMethod("kgelog_low")
}

kgelog_low <- yardstick::new_numeric_metric(
  kgelog_low,
  direction = "maximize"
)

#' @rdname kgelog
#' @export
kgelog_low.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "kgelog_low",
    fn = kgelog_low_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname kgelog
#' @export
kgelog_low_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  # checks
  checkmate::assert_numeric(
    truth,
    lower = 1e-323
  )
  checkmate::assert_numeric(
    estimate,
    lower = 1e-323
  )

  # Keep only low flows
  min_q <- min(truth, na.rm = TRUE)
  max_q <- max(truth, na.rm = TRUE)
  threshold <- (min_q + 0.05 * (max_q - min_q))
  checks <- truth <= threshold

  # Log-transform
  truth_log <- log10(truth[checks])
  estimate_log <- log10(estimate[checks])

  # More checks
  yardstick::check_numeric_metric(
    truth_log,
    estimate_log,
    case_weights = NULL
  )

  kge_cpp(
    truth_log,
    estimate_log,
    na_rm = na_rm,
    version = "2012"
  )
}

#' @rdname kgelog
#' @export
kgelog_hi <- function(data, ...) {
  UseMethod("kgelog_hi")
}

kgelog_hi <- yardstick::new_numeric_metric(
  kgelog_hi,
  direction = "maximize"
)

#' @rdname kgelog
#' @export
kgelog_hi.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "kgelog_hi",
    fn = kgelog_hi,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm
  )
}

#' @rdname kgelog
#' @export
kgelog_hi_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  ...
) {
  # checks
  checkmate::assert_numeric(
    truth,
    lower = 1e-323
  )
  checkmate::assert_numeric(
    estimate,
    lower = 1e-323
  )

  # Keep only low flows
  min_q <- min(truth, na.rm = TRUE)
  max_q <- max(truth, na.rm = TRUE)
  threshold <- (min_q + 0.05 * (max_q - min_q))
  checks <- truth > threshold

  # Log-transform
  truth_log <- log10(truth[checks])
  estimate_log <- log10(estimate[checks])

  # More checks
  yardstick::check_numeric_metric(
    truth_log,
    estimate_log,
    case_weights = NULL
  )

  kge_cpp(
    truth_log,
    estimate_log,
    na_rm = na_rm,
    version = "2012"
  )
}
