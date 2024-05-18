
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyhydro

<!-- badges: start -->

[![R-CMD-check](https://github.com/atsyplenkov/tidyhydro/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/atsyplenkov/tidyhydro/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidyhydro)](https://CRAN.R-project.org/package=tidyhydro)
![GitHub R package
version](https://img.shields.io/github/r-package/v/atsyplenkov/tidyhydro?label=github)
![GitHub last
commit](https://img.shields.io/github/last-commit/atsyplenkov/tidyhydro)
<!-- badges: end -->

The `tidyhydro` package provides a set of commonly used metrics in
hydrology (such as NSE, KGE, pBIAS) for use within a
[`tidymodels`](https://www.tidymodels.org/) infrastructure. Originally
inspired by the
[`yardstick`](https://github.com/tidymodels/yardstick/tree/main)and
[`hydroGOF`](https://github.com/hzambran/hydroGOF) packages, this
library is mainly written in C++ and provides a very quick estimation of
desired goodness-of-fit criteria.

## Installation

You can install the development version of `tidyhydro` from
[GitHub](https://github.com/atsyplenkov/tidyhydro) with:

``` r
# install.packages("devtools")
devtools::install_github("atsyplenkov/tidyhydro")

# OR

# install.packages("pak")
pak::pak("atsyplenkov/tidyhydro")
```

## Example

The `tidyhydro` package follows the philosophy of
[`yardstick`](https://github.com/tidymodels/yardstick/tree/main) and
provides S3 class methods for vectors and data frames. For example, one
can estimate `NSE` and `pBIAS` for a data frame like this:

``` r
library(yardstick)
library(tidyhydro)
data(solubility_test)

nse(solubility_test, solubility, prediction)
#> # A tibble: 1 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>          <dbl>
#> 1 nse     standard       0.879
pbias(solubility_test, solubility, prediction)
#> # A tibble: 1 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>          <dbl>
#> 1 pbias   standard      -0.512
```

or create a
[`metric_set`](https://yardstick.tidymodels.org/reference/metric_set.html)
and estimate several parameters at once like this:

``` r
hydro_metrics <- yardstick::metric_set(nse, pbias)

hydro_metrics(solubility_test, solubility, prediction)
#> # A tibble: 2 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>          <dbl>
#> 1 nse     standard       0.879
#> 2 pbias   standard      -0.512
```

We do understand that sometimes one needs a qualitative interpretation
of the model; therefore, we populated every function with a
`performance` argument. When `performance = TRUE`, the metric
interpretation will be returned according to Moriasi et
al. ([2015](https://swat.tamu.edu/media/1312/moriasimodeleval.pdf)).

``` r
hydro_metrics(solubility_test, solubility, prediction, performance = TRUE)
#> # A tibble: 2 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>      <chr>    
#> 1 nse     standard   Excellent
#> 2 pbias   standard   Excellent
```

## Benchmarking

Since the package uses `Rcpp` in the background, it performs slightly
faster than its ancestors:

``` r
bench::mark(
  tidyhydro = tidyhydro::nse_vec(
    solubility_test$solubility,
    solubility_test$prediction
  ),
  hydroGOF = hydroGOF::NSE(
    sim = solubility_test$prediction,
    obs = solubility_test$solubility
  ),
  check = TRUE,
  relative = TRUE
)
#> # A tibble: 2 × 6
#>   expression   min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <dbl>  <dbl>     <dbl>     <dbl>    <dbl>
#> 1 tidyhydro   1      1         1.74       1       1   
#> 2 hydroGOF    2.08   1.96      1         16.0     3.45
```
