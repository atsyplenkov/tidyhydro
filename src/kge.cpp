#include <Rcpp.h>
#include <cmath>
#ifdef _OPENMP
#include <omp.h>
#endif
using namespace Rcpp;

// [[Rcpp::export]]
SEXP kge_cpp(NumericVector obs, NumericVector sim, bool na_rm = true) {
  if (obs.size() != sim.size()) {
    stop("'obs' and 'sim' must have the same length");
  }

  const int n = obs.size();
  double mean_obs = 0.0, mean_sim = 0.0;
  double sd_obs = 0.0, sd_sim = 0.0;
  double r_num = 0.0; // numerator for Pearson correlation
  int count = 0;

  // First pass: means
  if (na_rm) {
    double sum_obs = 0.0, sum_sim = 0.0;
    #pragma omp parallel for reduction(+:sum_obs, sum_sim, count) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(obs[i]) && !ISNAN(sim[i])) {
        sum_obs += obs[i];
        sum_sim += sim[i];
        count++;
      }
    }
    if (count == 0) return wrap(NA_REAL);

    mean_obs = sum_obs / count;
    mean_sim = sum_sim / count;
  } else {
    for (int i = 0; i < n; i++) {
      mean_obs += obs[i];
      mean_sim += sim[i];
    }
    mean_obs /= n;
    mean_sim /= n;
    count = n;
  }

  // Second pass: standard deviations and Pearson correlation numerator
  if (na_rm) {
    #pragma omp parallel for reduction(+:sd_obs, sd_sim, r_num) schedule(static) if(n > 1000)
    for (int i = 0; i < n; i++) {
      if (!ISNAN(obs[i]) && !ISNAN(sim[i])) {
        const double d_obs = obs[i] - mean_obs;
        const double d_sim = sim[i] - mean_sim;
        sd_obs += d_obs * d_obs;
        sd_sim += d_sim * d_sim;
        r_num  += d_obs * d_sim;
      }
    }
  } else {
    for (int i = 0; i < n; i++) {
      const double d_obs = obs[i] - mean_obs;
      const double d_sim = sim[i] - mean_sim;
      sd_obs += d_obs * d_obs;
      sd_sim += d_sim * d_sim;
      r_num  += d_obs * d_sim;
    }
  }

  if (sd_obs == 0.0 || sd_sim == 0.0) return wrap(NA_REAL);

  double r = r_num / std::sqrt(sd_obs * sd_sim);
  double alpha = std::sqrt(sd_sim / sd_obs);
  double beta = mean_sim / mean_obs;

  double kge = 1.0 - std::sqrt(std::pow(r - 1.0, 2.0) + std::pow(alpha - 1.0, 2.0) + std::pow(beta - 1.0, 2.0));

  return wrap(kge);
}
