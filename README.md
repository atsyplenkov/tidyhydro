
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyhydro

<!-- badges: start -->
<p align="center">
<a href="https://github.com/atsyplenkov/tidyhydro/releases">
<img src="https://img.shields.io/github/v/release/atsyplenkov/tidyhydro?style=flat&labelColor=1C2C2E&color=198ce7&logo=GitHub&logoColor=white"></a>
<!-- <a href="https://cran.r-project.org/package=tidyhydro">
        <img src="https://img.shields.io/cran/v/tidyhydro?style=flat&labelColor=1C2C2E&color=198ce7&logo=R&logoColor=white"></a> -->
<a href="https://app.codecov.io/gh/atsyplenkov/tidyhydro">
<img src="https://img.shields.io/codecov/c/gh/atsyplenkov/tidyhydro?style=flat&labelColor=1C2C2E&color=256bc0&logo=Codecov&logoColor=white"></a>
<a href="https://github.com/atsyplenkov/tidyhydro/actions/workflows/check-r-pkg.yaml">
<img src="https://img.shields.io/github/actions/workflow/status/atsyplenkov/tidyhydro/check-r-pkg.yaml?style=flat&labelColor=1C2C2E&color=256bc0&logo=GitHub%20Actions&logoColor=white"></a>
</p>
<!-- badges: end -->

The `tidyhydro` package provides a set of commonly used metrics in
hydrology (such as *NSE*, *KGE*, *pBIAS*) for use within a
[`tidymodels`](https://www.tidymodels.org/) infrastructure. Originally
inspired by the
[`yardstick`](https://github.com/tidymodels/yardstick/tree/main) and
[`hydroGOF`](https://github.com/hzambran/hydroGOF) packages, this
library is mainly written in C++ and provides a very quick estimation of
desired goodness-of-fit criteria.

Additionally, you’ll find here a C++ implementation of lesser-known yet
powerful metrics used in reports from the United States Geological
Survey (USGS) and the National Environmental Monitoring Standards (NEMS)
guidelines. Examples include *PRESS* (Prediction Error Sum of Squares),
*SFE* (Standard Factorial Error), and *MSPE* (Model Standard Percentage
Error) and others. Based on the equations from *Helsel et al.*
([2020](https://pubs.usgs.gov/publication/tm4A3)), *Rasmunsen et al.*
([2008](https://pubs.usgs.gov/tm/tm3c4/)), *Hicks et al.*
([2020](https://www.nems.org.nz/documents/suspended-sediment)) and etc.
(see documentation for details).

## Example

The `tidyhydro` package follows the philosophy of
[`yardstick`](https://github.com/tidymodels/yardstick/tree/main) and
provides S3 class methods for vectors and data frames. For example, one
can estimate `KGE`, `NSE` or `pBIAS` for a data frame like this:

``` r
library(tidyhydro)
str(avacha)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    365 obs. of  3 variables:
#>  $ date: Date, format: "2022-01-01" "2022-01-02" ...
#>  $ obs : num  76.2 76.2 76.3 76.3 76.4 76.4 76.5 76.5 76.6 76.6 ...
#>  $ sim : num  84.8 84.3 84 83.7 83.4 ...

kge(avacha, obs, sim)
#> # A tibble: 1 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>          <dbl>
#> 1 kge     standard       0.947
```

or create a
[`metric_set`](https://yardstick.tidymodels.org/reference/metric_set.html)
and estimate several parameters at once like this:

``` r
hydro_metrics <- yardstick::metric_set(nse, pbias)

hydro_metrics(avacha, obs, sim)
#> # A tibble: 2 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>          <dbl>
#> 1 nse     standard      0.895 
#> 2 pbias   standard      0.0540
```

We do understand that sometimes one needs a qualitative interpretation
of the model. Therefore, we populated some functions with a
`performance` argument. When `performance = TRUE`, the metric
interpretation will be returned according to Moriasi et
al. ([2015](https://elibrary.asabe.org/abstract.asp?aid=46548&t=3&dabs=Y&redir=&redirType=)).

``` r
hydro_metrics(avacha, obs, sim, performance = TRUE)
#> # A tibble: 2 × 3
#>   .metric .estimator .estimate
#>   <chr>   <chr>      <chr>    
#> 1 nse     standard   Excellent
#> 2 pbias   standard   Excellent
```

## Installation

You can install the development version of `tidyhydro` from
[GitHub](https://github.com/atsyplenkov/tidyhydro) with:

``` r
# install.packages("pak")
pak::pak("atsyplenkov/tidyhydro")
```

## Benchmarking

Since the package uses `Rcpp` in the background, it performs slightly
faster than base R and other R packages (see
[benchmarks](https://atsyplenkov.github.io/tidyhydro/articles/benchmarks.html)).
This is particularly noticeable with large datasets:

``` r
set.seed(12234)
x <- runif(10^6)
y <- runif(10^6)

nse <- function(truth, estimate, na_rm = TRUE) {
  #fmt: skip
  1 - (sum((truth - estimate)^2, na.rm = na_rm) /
        sum((truth - mean(truth, na.rm = na_rm))^2, na.rm = na_rm))
}

bench::mark(
  tidyhydro = tidyhydro::nse_vec(truth = x, estimate = y),
  hydroGOF = hydroGOF::NSE(sim = y, obs = x),
  baseR = nse(truth = x, estimate = y),
  check = TRUE,
  relative = TRUE,
  filter_gc = FALSE,
  iterations = 50L
)
#> # A tibble: 3 × 6
#>   expression   min median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <dbl>  <dbl>     <dbl>     <dbl>    <dbl>
#> 1 tidyhydro   1       1       22.7        NaN      NaN
#> 2 hydroGOF   15.2    19.1      1          Inf      Inf
#> 3 baseR       8.66   10.6      2.44       Inf      Inf
```

## Code of Conduct

Please note that the tidyhydro project is released with a [Contributor
Code of
Conduct](https://atsyplenkov.github.io/tidyhydro/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## See also

-   [`hydroGOF`](https://github.com/hzambran/hydroGOF) - Goodness-of-fit
    functions for comparison of simulated and observed hydrological time
    series.
-   [`yardstick`](https://github.com/tidymodels/yardstick/tree/main) -
    tidy methods for models performance assessment.
