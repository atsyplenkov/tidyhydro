test_that("na_rm works as expected", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  # No missing data, na.rm = FALSE
  expect_equal(
    kge_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = FALSE),
    #fmt: skip
    1 - sqrt(
          (cor(ex_dat$pred, ex_dat$obs) - 1)^2 +
            (sd(ex_dat$pred) / sd(ex_dat$obs) - 1)^2 +
            (mean(ex_dat$pred) / mean(ex_dat$obs) - 1)^2
        )
  )

  # No missing data, na.rm = TRUE
  expect_equal(
    kge_vec(truth = ex_dat$obs, estimate = ex_dat$pred, na_rm = TRUE),
    #fmt: skip
    1 - sqrt(
          (cor(ex_dat$pred, ex_dat$obs) - 1)^2 +
            (sd(ex_dat$pred) / sd(ex_dat$obs) - 1)^2 +
            (mean(ex_dat$pred) / mean(ex_dat$obs) - 1)^2
        )
  )

  # Missing data is present, na.rm = FALSE
  expect_equal(
    kge_vec(truth = ex_dat$obs, estimate = ex_dat$pred_na, na_rm = FALSE),
    NA_real_
  )

  # Missing data is present, na.rm = TRUE
  expect_equal(
    kge(ex_dat, truth = obs, estimate = pred_na, na_rm = TRUE)[[".estimate"]],
    #fmt: skip
    1 - sqrt(
          (cor(ex_dat$pred[not_na], ex_dat$obs[not_na]) - 1)^2 +
            (sd(ex_dat$pred[not_na]) / sd(ex_dat$obs[not_na]) - 1)^2 +
            (mean(ex_dat$pred[not_na]) / mean(ex_dat$obs[not_na]) - 1)^2
        ),
    tolerance = 0.0001
  )
})

test_that("Integer columns are allowed", {
  ex_dat <- generate_numeric_test_data()
  ex_dat$obs <- as.integer(ex_dat$obs)

  expect_equal(
    kge(ex_dat, truth = "obs", estimate = "pred", na_rm = FALSE)[[".estimate"]],
    #fmt: skip
    1 - sqrt(
          (cor(ex_dat$pred, ex_dat$obs) - 1)^2 +
            (sd(ex_dat$pred) / sd(ex_dat$obs) - 1)^2 +
            (mean(ex_dat$pred) / mean(ex_dat$obs) - 1)^2
        )
  )
})

test_that("Result similar to {hydroGOF} package", {
  skip_if_not_installed("hydroGOF")

  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  # General case
  expect_equal(
    kge(ex_dat, truth = "obs", estimate = "pred", na_rm = FALSE)[[".estimate"]],
    hydroGOF::KGE(obs = ex_dat$obs, sim = ex_dat$pred)
  )

  # With missing data
  expect_equal(
    kge_vec(truth = ex_dat$obs, estimate = ex_dat$pred_na, na_rm = TRUE),
    hydroGOF::KGE(obs = ex_dat$obs, sim = ex_dat$pred_na, na.rm = TRUE),
    tolerance = 0.0001
  )
})
