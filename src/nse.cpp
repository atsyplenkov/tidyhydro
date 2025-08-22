#include <Rcpp.h>
// [[Rcpp::plugins(openmp)]]
#ifdef _OPENMP
#include <omp.h>
#endif
using namespace Rcpp;

// [[Rcpp::export]]
SEXP nse_cpp(NumericVector truth, NumericVector estimate, bool performance = false, bool na_rm = true) {
  if (truth.size() != estimate.size()) {
    stop("'truth' and 'estimate' must have the same length");
  }
  
  const int n = truth.length();
  const double* t = REAL(truth);
  const double* e = REAL(estimate);
  double num = 0.0;  // numerator
  double den = 0.0;  // denominator
  double t_mean = 0.0; // mean of truth
  
  // First pass: calculate mean and handle NAs
  if (na_rm) {
    double sum = 0.0;
    int count = 0;
    
    #pragma omp parallel for reduction(+:sum,count) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(t[i]) && !ISNAN(e[i])) {
        sum += t[i];
        count++;
      }
    }
    
    t_mean = sum / count;
  } else {
    #pragma omp parallel for reduction(+:t_mean) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      t_mean += t[i];
    }
    t_mean /= n;
  }
  
  // Second pass: calculate numerator and denominator
  if (na_rm) {
    #pragma omp parallel for reduction(+:num,den) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(t[i]) && !ISNAN(e[i])) {
        const double diff1 = t[i] - e[i];
        const double diff2 = t[i] - t_mean;
        num += diff1 * diff1;
        den += diff2 * diff2;
      }
    }
  } else {
    #pragma omp parallel for simd reduction(+:num,den) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      const double diff1 = t[i] - e[i];
      const double diff2 = t[i] - t_mean;
      num += diff1 * diff1;
      den += diff2 * diff2;
    }
  }
  
  double metric = 1.0 - (num / den);
  
  if (!performance) {
    return wrap(metric);
  } else {
    CharacterVector metric_values = CharacterVector::create("Poor", "Satisfactory", "Good", "Excellent");
    CharacterVector result(1);
    
    if (metric <= 0.5) {
      result[0] = metric_values[0];
    } else if (metric > 0.5 && metric < 0.6) {
      result[0] = metric_values[1];
    } else if (metric >= 0.6 && metric <= 0.8) {
      result[0] = metric_values[2];
    } else {
      result[0] = metric_values[3];
    }
    
    return result;
  }
}
