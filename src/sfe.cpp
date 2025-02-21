#include <Rcpp.h>
// [[Rcpp::plugins(openmp)]]
#ifdef _OPENMP
#include <omp.h>
#endif
using namespace Rcpp;

// [[Rcpp::export]]
SEXP sfe_cpp(NumericVector truth, NumericVector estimate, bool na_rm = true) {
  if (truth.size() != estimate.size()) {
    stop("'truth' and 'estimate' must have the same length");
  }

  const int n = truth.length();
  const double* t = REAL(truth);
  const double* e = REAL(estimate);
  double sum_log_ratio_squared = 0.0;
  int valid_n = 0;
  bool has_invalid = false;

  if (na_rm) {
    #pragma omp parallel for reduction(+:sum_log_ratio_squared,valid_n) reduction(|:has_invalid) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(t[i]) && !ISNAN(e[i]) && t[i] != 0 && e[i] != 0) {
        double log_ratio = std::log(std::abs(t[i] / e[i]));
        sum_log_ratio_squared += log_ratio * log_ratio;
        valid_n++;
      }
    }
  } else {
    #pragma omp parallel for reduction(+:sum_log_ratio_squared) reduction(|:has_invalid) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (t[i] == 0 || e[i] == 0) {
        has_invalid = true;
      } else {
        double log_ratio = std::log(std::abs(t[i] / e[i]));
        sum_log_ratio_squared += log_ratio * log_ratio;
      }
    }
    valid_n = has_invalid ? 0 : n;
  }

  if (valid_n == 0 || has_invalid) {
    return wrap(R_NaN);
  }

  double s = std::sqrt(sum_log_ratio_squared / valid_n);
  return wrap(std::exp(s));
}
