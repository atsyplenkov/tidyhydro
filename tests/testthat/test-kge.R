requireNamespace("hydroGOF", quietly = TRUE)

test_that("kge", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  # expect_equal(
  #   kge(ex_dat, truth = "obs", estimate = "pred", na_rm = TRUE)[[".estimate"]],
  #   1 -
  #     sqrt(
  #       (cor(ex_dat$pred[not_na], ex_dat$obs[not_na]) - 1)^2 +
  #         (sd(ex_dat$pred[not_na]) / sd(ex_dat$obs[not_na]) - 1)^2 +
  #         (mean(ex_dat$pred[not_na]) / mean(ex_dat$obs[not_na]) - 1)^2
  #     )
  # )
  expect_equal(
    kge(ex_dat, truth = obs, estimate = "pred_na", na_rm = FALSE)[[
      ".estimate"
    ]],
    NA_real_
  )
})

test_that("Integer columns are allowed", {
  ex_dat <- generate_numeric_test_data()
  ex_dat$obs <- as.integer(ex_dat$obs)

  expect_equal(
    kge(ex_dat, truth = "obs", estimate = "pred", na.rm = FALSE)[[".estimate"]],
    1 -
      sqrt(
        (cor(ex_dat$pred, ex_dat$obs) - 1)^2 +
          (sd(ex_dat$pred) / sd(ex_dat$obs) - 1)^2 +
          (mean(ex_dat$pred) / mean(ex_dat$obs) - 1)^2
      )
  )
})

test_that("Result similar to {hydroGOF} package", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  expect_equal(
    kge(ex_dat, truth = "obs", estimate = "pred", na.rm = FALSE)[[".estimate"]],
    hydroGOF::KGE(obs = ex_dat$obs, sim = ex_dat$pred)
  )

  expect_equal(
    kge(ex_dat, truth = "obs", estimate = "pred_na", na.rm = TRUE)[[
      ".estimate"
    ]],
    hydroGOF::KGE(obs = ex_dat$obs[not_na], sim = ex_dat$pred[not_na]),
    tolerance = 0.01
  )
})
