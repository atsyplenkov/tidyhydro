test_that("na_rm works as expected", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  # No missing data, na.rm = FALSE
  expect_equal(
    mse_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = FALSE),
    mean((ex_dat$pred - ex_dat$obs)^2)
  )
  expect_equal(
    rmse_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = FALSE),
    sqrt(mean((ex_dat$pred - ex_dat$obs)^2))
  )

  # No missing data, na.rm = TRUE
  expect_equal(
    mse_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = TRUE),
    mean((ex_dat$pred - ex_dat$obs)^2)
  )
  expect_equal(
    rmse_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = TRUE),
    sqrt(mean((ex_dat$pred - ex_dat$obs)^2))
  )

  # Missing data is present, na.rm = FALSE
  expect_equal(
    mse_vec(truth = ex_dat$obs, estimate = ex_dat$pred_na, na_rm = FALSE),
    NA_real_
  )
  expect_equal(
    rmse_vec(truth = ex_dat$obs, estimate = ex_dat$pred_na, na_rm = FALSE),
    NA_real_
  )

  # Missing data is present, na.rm = TRUE
  expect_equal(
    mse(ex_dat, truth = obs, estimate = pred_na, na_rm = TRUE)[[".estimate"]],
    mean((ex_dat$pred_na - ex_dat$obs)^2, na.rm = TRUE)
  )
  expect_equal(
    rmse(ex_dat, truth = obs, estimate = pred_na, na_rm = TRUE)[[".estimate"]],
    sqrt(mean((ex_dat$pred_na - ex_dat$obs)^2, na.rm = TRUE))
  )
})

test_that("Integer columns are allowed", {
  ex_dat <- generate_numeric_test_data()
  ex_dat$obs <- as.integer(ex_dat$obs)

  expect_equal(
    mse(ex_dat, truth = "obs", estimate = "pred", na_rm = FALSE)[[".estimate"]],
    mean((ex_dat$pred - ex_dat$obs)^2, na.rm = FALSE)
  )
  expect_equal(
    rmse(ex_dat, truth = "obs", estimate = "pred", na_rm = FALSE)[[".estimate"]],
    sqrt(mean((ex_dat$pred - ex_dat$obs)^2, na.rm = FALSE))
  )
})
