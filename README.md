
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyhydro

<!-- badges: start -->

[![R-CMD-check](https://github.com/atsyplenkov/tidyhydro/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/atsyplenkov/tidyhydro/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of tidyhydro is to …

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
