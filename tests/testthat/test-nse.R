test_that("na_rm works as expected", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  # No missing data, na.rm = FALSE
  expect_equal(
    nse_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = FALSE),
    #fmt:skip
    1 - (sum((ex_dat$obs - ex_dat$pred)^2) /
          sum((ex_dat$obs - mean(ex_dat$obs))^2))
  )
  # No missing data, na.rm = TRUE
  expect_equal(
    nse_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = TRUE),
    #fmt:skip
    1 - (sum((ex_dat$obs - ex_dat$pred)^2) /
          sum((ex_dat$obs - mean(ex_dat$obs))^2))
  )

  # Missing data is present, na.rm = FALSE
  expect_equal(
    nse_vec(truth = ex_dat$obs, estimate = ex_dat$pred_na, na_rm = FALSE),
    NA_real_
  )

  # Missing data is present, na.rm = TRUE
  expect_equal(
    nse(ex_dat, truth = obs, estimate = pred_na, na_rm = TRUE)[[".estimate"]],
    #fmt:skip
    1 - (sum((ex_dat$obs[not_na] - ex_dat$pred[not_na])^2) /
          sum((ex_dat$obs[not_na] - mean(ex_dat$obs[not_na]))^2))
  )
})

test_that("Integer columns are allowed", {
  ex_dat <- generate_numeric_test_data()
  ex_dat$obs <- as.integer(ex_dat$obs)

  expect_equal(
    nse(ex_dat, truth = "obs", estimate = "pred", na_rm = FALSE)[[".estimate"]],
    #fmt:skip
    1 - (sum((ex_dat$obs - ex_dat$pred)^2) /
          sum((ex_dat$obs - mean(ex_dat$obs))^2))
  )
})

test_that("Result interpretation is returned", {
  ex_dat <- generate_numeric_test_data()

  expect_equal(
    nse_vec(truth = ex_dat$obs, estimate = ex_dat$pred, performance = TRUE),
    "Good"
  )
})
