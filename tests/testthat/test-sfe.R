test_that("sfe", {
  set.seed(123)
  ex_dat <- generate_numeric_test_data()

  sfe_r <- function(truth, estimate, na_rm) {
    if (na_rm) {
      missing <- is.na(truth) | is.na(estimate)
      n <- sum(!missing)
    } else {
      n <- length(truth)
    }
    s <- sqrt(sum(log(abs(truth / estimate))^2, na.rm = na_rm) / n)
    exp(s)
  }

  expect_equal(
    sfe(
      ex_dat,
      truth = "obs",
      estimate = "pred",
      na_rm = FALSE
    )[[".estimate"]],
    sfe_r(ex_dat$obs, ex_dat$pred, na_rm = FALSE)
  )
  expect_equal(
    sfe(
      ex_dat,
      truth = obs,
      estimate = pred_na,
      na_rm = TRUE
    )[[".estimate"]],
    sfe_r(ex_dat$obs, ex_dat$pred_na, na_rm = TRUE)
  )
})
