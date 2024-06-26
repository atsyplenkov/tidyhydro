#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
SEXP pbias_cpp(NumericVector truth, NumericVector estimate, bool performance = false, bool na_rm = true)
{

  // Removing NA values if na_rm is TRUE
  if (na_rm)
  {

    std::vector<int> naIndices;

    // Check for NaN in 'truth'
    for (size_t i = 0; i < static_cast<size_t>(truth.size()); ++i)
    {
      if (std::isnan(truth[i]))
      {
        naIndices.push_back(i);
      }
    }

    // Check for NaN in 'estimate'
    for (size_t i = 0; i < static_cast<size_t>(estimate.size()); ++i)
    {
      if (std::isnan(estimate[i]))
      {
        naIndices.push_back(i);
      }
    }

    // Sort the indices
    std::sort(naIndices.begin(), naIndices.end());

    // Remove duplicates
    auto last = std::unique(naIndices.begin(), naIndices.end());
    naIndices.erase(last, naIndices.end());

    // Create new vectors without NA elements
    NumericVector cleaned_truth(truth.size() - naIndices.size());
    NumericVector cleaned_estimate(estimate.size() - naIndices.size());

    int index = 0;
    for (int i = 0; i < truth.size(); ++i)
    {
      if (!std::binary_search(naIndices.begin(), naIndices.end(), i))
      {
        cleaned_truth[index] = truth[i];
        cleaned_estimate[index] = estimate[i];
        index++;
      }
    }

    truth = cleaned_truth;
    estimate = cleaned_estimate;
  }

  double metric = 100 * (sum(estimate - truth) / sum(truth));

  if (!performance)
  {
    return wrap(metric);
  }
  else
  {
    CharacterVector metric_values = CharacterVector::create("Poor", "Satisfactory", "Good", "Excellent");
    CharacterVector result(1);

    if (abs(metric) >= 15)
    {
      result[0] = metric_values[0];
    }
    else if (abs(metric) >= 10 && abs(metric) < 15)
    {
      result[0] = metric_values[1];
    }
    else if (abs(metric) >= 5 && abs(metric) < 10)
    {
      result[0] = metric_values[2];
    }
    else
    {
      result[0] = metric_values[3];
    }

    return result;
  }
}
