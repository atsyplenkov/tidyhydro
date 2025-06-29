#include <Rcpp.h>
// [[Rcpp::plugins(openmp)]]
#ifdef _OPENMP
#include <omp.h>
#endif
using namespace Rcpp;

// [[Rcpp::export]]
SEXP mse_cpp(NumericVector truth, NumericVector estimate, bool na_rm = true, bool sqrt = true) {
  if (truth.size() != estimate.size()) {
    stop("'truth' and 'estimate' must have the same length");
  }
  
  const int n = truth.length();
  const double* t = REAL(truth);
  const double* e = REAL(estimate);
  double num = 0.0;  // numerator
  double den = 0.0;  // denominator
  
  if (na_rm) {
    #pragma omp parallel for reduction(+:num,den) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(t[i]) && !ISNAN(e[i])) {
        const double diff1 = t[i] - e[i];
        num += diff1 * diff1;
        den += 1.0;
      }
    }
  } else {
    #pragma omp parallel for simd reduction(+:num,den) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      const double diff1 = t[i] - e[i];
      num += diff1 * diff1;
      den += 1.0;
    }
  }
  
  // Wheter to return MSE or RMSE 
  double metric;
  if (sqrt){
    // Root Mean Squared Error
    metric = std::sqrt(num / den); 
  } else {
    // Mean Squared Error
    metric = num / den;
  }

  return wrap(metric);
}
