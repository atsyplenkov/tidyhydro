#include <Rcpp.h>
// [[Rcpp::plugins(openmp)]]
#ifdef _OPENMP
#include <omp.h>
#endif
using namespace Rcpp;

// Enable compiler optimizations
// [[Rcpp::export]]
SEXP press_cpp(NumericVector truth, NumericVector estimate, bool na_rm = true) {
  if (truth.size() != estimate.size()) {
    stop("'truth' and 'estimate' must have the same length");
  }
  
  const int n = truth.length();
  const double* t = REAL(truth);
  const double* e = REAL(estimate);
  double sum = 0.0;
  
  if (na_rm) {
    #pragma omp parallel for reduction(+:sum) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(t[i]) && !ISNAN(e[i])) {
        const double diff = t[i] - e[i];
        sum += diff * diff;
      }
    }
  } else {
    #pragma omp parallel for simd reduction(+:sum) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      const double diff = t[i] - e[i];
      sum += diff * diff;
    }
  }
  
  return wrap(sum);
}
