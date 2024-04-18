
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
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("atsyplenkov/tidyhydro")
```

## Example

``` r
library(yardstick)
library(tidyhydro)
data(solubility_test)

nse(solubility_test, solubility, prediction)
#> # A tibble: 1 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>          <dbl>
#> 1 nse     standard       0.879
```

## Benchmarking

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
#> 1 tidyhydro   1      1         2.23       1       1   
#> 2 hydroGOF    2.55   2.43      1         10.7     1.34
```
