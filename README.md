
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyhydro

<!-- badges: start -->

[![R-CMD-check](https://github.com/atsyplenkov/tidyhydro/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/atsyplenkov/tidyhydro/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidyhydro)](https://CRAN.R-project.org/package=tidyhydro)
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
al. ([2015](https://elibrary.asabe.org/abstract.asp?aid=46548&t=3&dabs=Y&redir=&redirType=)).

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
faster than base R and other R packages:

``` r
x <- runif(10^5)
y <- runif(10^5)

nse <- function(truth, estimate, na_rm = TRUE) {
  1 - (sum((truth - estimate)^2, na.rm = na_rm) /
        sum((truth - mean(truth, na.rm = na_rm))^2, na.rm = na_rm))
}

bench::mark(
  tidyhydro = tidyhydro::nse_vec(truth = x, estimate = y),
  hydroGOF = hydroGOF::NSE(sim = y, obs = x),
  baseR = nse(truth = x, estimate = y),
  check = TRUE,
  relative = TRUE,
  iterations = 100L
)
#> # A tibble: 3 × 6
#>   expression   min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <dbl>  <dbl>     <dbl>     <dbl>    <dbl>
#> 1 tidyhydro   1      1        11.7        NaN      NaN
#> 2 hydroGOF   12.3   12.6       1          Inf      Inf
#> 3 baseR       7.57   7.65      1.78       Inf      Inf
```

## See also

-   [`hydroGOF`](https://github.com/hzambran/hydroGOF) - Goodness-of-fit
    functions for comparison of simulated and observed hydrological time
    series
