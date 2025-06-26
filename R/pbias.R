#' Percent BIAS (pBIAS)
#'
#' @description
#' \eqn{pBIAS} is the deviation of data being evaluated, expressed as a 
#' percentage. It measures the average tendency of the simulated data to be 
#' larger or smaller than their observed counterparts (*Moriasi et al., 2015*). 
#' The optimal value of \eqn{pBIAS} is 0.0, with low-magnitude values 
#' indicating accurate mode simulation. Positive values indicate model 
#' underestimation bias, and negative values indicate model overestimation 
#' bias (*Gupta et al., 1999*).
#'
#' @details
#' The formula for \eqn{pBIAS} is:
#'
#' \deqn{
#'   pBIAS = 100 \times \frac{\sum_{i=1}^{n}{(sim_i - obs_i)}}
#'                           {\sum_{i=1}^{n}{obs_i}}
#' }
#' 
#' where:
#' \itemize{
#'   \item \eqn{sim} defines model simulations at time step \eqn{i}
#'   \item \eqn{obs} defines model observations at time step \eqn{i}
#' }
#' 
#' According to Moriasi et al. (2015) the metric interpretation can be as
#' follows:
#'
#' - **Excellent**/**Very Good** -- `pbias()` < ±5.0
#' - **Good** -- ±5.0 <= `pbias()` < ±10.0
#' - **Satisfactory** -- ±10.0 <= `pbias()` < ±15.0
#' - **Poor** -- `pbias()` >= ±15.0
#'
#' @family numeric metrics
#' @family accuracy metrics
#' @templateVar fn pbias
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
#' @param performance The optional column, indicating should the `pbias()`
#' return metric interpretation. See details.
#'
#' @param ... Not currently used.
#'
#' @references
#' Moriasi, D. N., Gitau, M. W., Pai, N., & Daggupati, P. (2015). Hydrologic
#'  and Water Quality Models: Performance Measures and Evaluation Criteria.
#'  Transactions of the ASABE, 58(6), 1763–1785.
#'  \doi{10.13031/trans.58.10715}
#'
#' Gupta, H. V., S. Sorooshian, and P. O. Yapo. (1999).
#'  Status of automatic calibration for hydrologic models: Comparison with
#'  multilevel expert calibration. J. Hydrologic Eng. 4(2): 135-143
#'  \doi{10.1061/(ASCE)1084-0699(1999)4:2(135)}
#'
#' @template examples-numeric
#'
#' @export
#'
pbias <- function(data, ...) {
  UseMethod("pbias")
}

pbias <- yardstick::new_numeric_metric(
  pbias,
  direction = "minimize"
)

#' @rdname pbias
#' @export
pbias.data.frame <- function(
  data,
  truth,
  estimate,
  na_rm = TRUE,
  performance = FALSE,
  ...
) {
  yardstick::numeric_metric_summarizer(
    name = "pbias",
    fn = pbias_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    na_rm = na_rm,
    fn_options = list(performance = performance)
  )
}

#' @rdname pbias
#' @export
pbias_vec <- function(
  truth,
  estimate,
  na_rm = TRUE,
  performance = FALSE,
  ...
) {
  yardstick::check_numeric_metric(truth, estimate, case_weights = NULL)

  pbias_cpp(truth, estimate, na_rm = na_rm, performance = performance)
}
