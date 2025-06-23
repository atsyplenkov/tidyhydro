# tidyhydro 0.1.0

## New features
* Added Kling-Gupta Efficiency (`kge`)
* Added Mean Squared Error (`mse`)

## Bug fixes
* `nse` with `na_rm = TRUE` flag and missing values present in both simulated and observed time series now returns the same results as `hydroGOF::NSE()`. Previously, it did not skip missing values in the observed time series.

## Miscellaneous
* Introduced parameter testing via `quickcheck`. Estimated metrics are now validated against their implementations in the `hydroGOF` package.
* Removed unnecessary dependencies (`dplyr` and `bench`).

# tidyhydro 0.0.4
## New features
* Added Standard Factorial Error (`sfe`)

# tidyhydro 0.0.3
## New features
* Added PRediction Error Sum of Squares (`press`)