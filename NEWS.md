# tidyhydro 0.1.2

## New features
-   Added RMSE (`rmse`) and log-transformed KGE (`kgelog`, `kgelog_low` and `kgelog_hi`)
-   Introduced descriptive statistics class — `measure`
-   Added `cv`, `gm` measures

## Miscellaneous

-   Added structure. Functions are now grouped into three categories: GOF, regression and descriptive statistics
-   Improved parameter testing via `quickcheck`

# tidyhydro 0.1.1

## New features

-   Added support for modified Kling-Gupta Efficiency (`kge2012`), aka $KGE'$ ([#8](https://github.com/atsyplenkov/tidyhydro/issues/8))
-   Added vignettes and website ([#14](https://github.com/atsyplenkov/tidyhydro/issues/14))

## Bug fixes

-   Improved documentation by switching from `\url` to `\doi`
-   Removed unicode characters

## Miscellaneous

-   Created website with vignettes (https://atsyplenkov.github.io/tidyhydro)

# tidyhydro 0.1.0

## New features

-   Added Kling-Gupta Efficiency (`kge`).
-   Added Mean Squared Error (`mse`).
-   Added example dataset (`avacha`) with observed and modelled daily water discharge measurements in cubic meters per second ([#6](https://github.com/atsyplenkov/tidyhydro/issues/6)).

## Bug fixes

-   `nse` with `na_rm = TRUE` flag and missing values present in both simulated and observed time series now returns the same results as `hydroGOF::NSE()`. Previously, it did not skip missing values in the observed time series.

## Miscellaneous

-   Introduced parameter testing via `quickcheck` ([#3](https://github.com/atsyplenkov/tidyhydro/issues/3)). Estimated metrics are now validated against their implementations in the `hydroGOF` package.
-   Removed unnecessary dependencies ([#2](https://github.com/atsyplenkov/tidyhydro/issues/2)).
-   Updated documentation with equations and references.

# tidyhydro 0.0.4

## New features

-   Added Standard Factorial Error (`sfe`).

# tidyhydro 0.0.3

## New features

-   Added PRediction Error Sum of Squares (`press`).
