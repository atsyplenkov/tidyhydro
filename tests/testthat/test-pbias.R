test_that("na_rm works as expected", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  # No missing data, na.rm = FALSE
  expect_equal(
    pbias_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = FALSE),
    #fmt:skip
    100 * (sum(ex_dat$pred - ex_dat$obs) / sum(ex_dat$obs))
  )
  # No missing data, na.rm = TRUE
  expect_equal(
    pbias_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = TRUE),
    #fmt:skip
    100 * (sum(ex_dat$pred - ex_dat$obs) / sum(ex_dat$obs))
  )

  # Missing data is present, na.rm = FALSE
  expect_equal(
    pbias_vec(truth = ex_dat$obs, estimate = ex_dat$pred_na, na_rm = FALSE),
    NA_real_
  )

  # Missing data is present, na.rm = TRUE
  expect_equal(
    pbias(ex_dat, truth = obs, estimate = pred_na, na_rm = TRUE)[[".estimate"]],
    #fmt:skip
    100 * 
      (sum(ex_dat$pred[not_na] - ex_dat$obs[not_na]) / sum(ex_dat$obs[not_na])),
    tolerance = 0.0001
  )
})

test_that("Integer columns are allowed", {
  ex_dat <- generate_numeric_test_data()
  ex_dat$obs <- as.integer(ex_dat$obs)

  expect_equal(
    pbias_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = FALSE),
    #fmt:skip
    100 * (sum(ex_dat$pred - ex_dat$obs) / sum(ex_dat$obs))
  )
})

test_that("Result similar to {hydroGOF} package", {
  skip_if_not_installed("hydroGOF")

  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  # General case
  expect_equal(
    pbias_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = FALSE),
    hydroGOF::pbias(obs = ex_dat$obs, sim = ex_dat$pred),
    tolerance = 0.1
  )

  # With missing data
  expect_equal(
    pbias_vec(truth = ex_dat$obs, estimate = ex_dat$pred_na, na_rm = TRUE),
    hydroGOF::pbias(obs = ex_dat$obs, sim = ex_dat$pred_na, na.rm = TRUE),
    tolerance = 0.0001
  )
})

test_that("Result interpretation is returned", {
  ex_dat <- generate_numeric_test_data()

  expect_equal(
    pbias_vec(truth = ex_dat$obs, estimate = ex_dat$pred, performance = TRUE),
    "Poor"
  )
})
