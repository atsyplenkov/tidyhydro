#include <Rcpp.h>
// [[Rcpp::plugins(openmp)]]
#ifdef _OPENMP
#include <omp.h>
#endif
using namespace Rcpp;

// [[Rcpp::export]]
SEXP pbias_cpp(NumericVector truth, NumericVector estimate, bool performance = false, bool na_rm = true)
{
  if (truth.size() != estimate.size()) {
    stop("'truth' and 'estimate' must have the same length");
  }

  const int n = truth.length();
  const double* t = REAL(truth);
  const double* e = REAL(estimate);
  double num = 0.0;  // sum(estimate - truth)
  double den = 0.0;  // sum(truth)

  if (na_rm) {
    #pragma omp parallel for reduction(+:num,den) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(t[i]) && !ISNAN(e[i])) {
        num += e[i] - t[i];
        den += t[i];
      }
    }
  } else {
    #pragma omp parallel for simd reduction(+:num,den) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      num += e[i] - t[i];
      den += t[i];
    }
  }

  double metric = 100.0 * (num / den);

  if (!performance) {
    return wrap(metric);
  } else {
    CharacterVector metric_values = CharacterVector::create("Poor", "Satisfactory", "Good", "Excellent");
    CharacterVector result(1);
    
    const double abs_metric = std::abs(metric);
    
    if (abs_metric >= 15.0) {
      result[0] = metric_values[0];
    } else if (abs_metric >= 10.0) {
      result[0] = metric_values[1];
    } else if (abs_metric >= 5.0) {
      result[0] = metric_values[2];
    } else {
      result[0] = metric_values[3];
    }

    return result;
  }
}
