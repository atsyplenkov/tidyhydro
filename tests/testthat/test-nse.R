requireNamespace("hydroGOF", quietly = TRUE)

test_that("nse", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  expect_equal(
    nse(ex_dat, truth = "obs", estimate = "pred", na.rm = FALSE)[[".estimate"]],
    1 -
      (
        sum((ex_dat$obs - ex_dat$pred)^2) /
          sum((ex_dat$obs - mean(ex_dat$obs))^2)
      )
  )
  expect_equal(
    nse(ex_dat, truth = obs, estimate = "pred_na", na_rm = TRUE)[[".estimate"]],
    1 -
      (
        sum((ex_dat$obs[not_na] - ex_dat$pred[not_na])^2) /
          sum((ex_dat$obs[not_na] - mean(ex_dat$obs[not_na]))^2)
      )
  )
})

test_that("Integer columns are allowed", {
  ex_dat <- generate_numeric_test_data()
  ex_dat$obs <- as.integer(ex_dat$obs)

  expect_equal(
    nse(ex_dat, truth = "obs", estimate = "pred", na.rm = FALSE)[[".estimate"]],
    1 -
      (
        sum((ex_dat$obs - ex_dat$pred)^2) /
          sum((ex_dat$obs - mean(ex_dat$obs))^2)
      )
  )
})

test_that("Result similar to {hydroGOF} package", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  expect_equal(
    nse(ex_dat, truth = "obs", estimate = "pred", na.rm = FALSE)[[".estimate"]],
    hydroGOF::NSE(obs = ex_dat$obs, sim = ex_dat$pred)
  )

  expect_equal(
    nse(ex_dat, truth = "obs", estimate = "pred_na", na.rm = TRUE)[[
      ".estimate"
    ]],
    hydroGOF::NSE(obs = ex_dat$obs[not_na], sim = ex_dat$pred[not_na])
  )
})

test_that("Result interpretation is returned", {
  ex_dat <- generate_numeric_test_data()

  expect_equal(
    nse(ex_dat, truth = "obs", estimate = "pred", performance = TRUE)[[
      ".estimate"
    ]],
    "Satisfactory"
  )
})
