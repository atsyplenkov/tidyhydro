requireNamespace("hydroGOF", quietly = TRUE)

test_that("pbias correctly handles missing values", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  expect_equal(
    pbias(
      ex_dat,
      truth = "obs",
      estimate = "pred",
      na.rm = FALSE
    )[[".estimate"]],
    100 * (sum(ex_dat$pred - ex_dat$obs) / sum(ex_dat$obs))
  )
  expect_equal(
    pbias(
      ex_dat,
      truth = obs,
      estimate = "pred_na",
      na_rm = TRUE
    )[[".estimate"]],
    100 *
      (sum(ex_dat$pred[not_na] - ex_dat$obs[not_na]) / sum(ex_dat$obs[not_na]))
  )
})

test_that("Integer columns are allowed", {
  ex_dat <- generate_numeric_test_data()
  ex_dat$obs <- as.integer(ex_dat$obs)

  expect_equal(
    pbias(
      ex_dat,
      truth = "obs",
      estimate = "pred",
      na.rm = FALSE
    )[[".estimate"]],
    100 * (sum(ex_dat$pred - ex_dat$obs) / sum(ex_dat$obs))
  )
})

test_that("Result similar to {hydroGOF} package", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  expect_equal(
    round(
      pbias(
        ex_dat,
        truth = "obs",
        estimate = "pred",
        na.rm = FALSE
      )[[".estimate"]],
      1
    ),
    round(hydroGOF::pbias(obs = ex_dat$obs, sim = ex_dat$pred), 1)
  )

  expect_equal(
    round(
      pbias(
        ex_dat,
        truth = "obs",
        estimate = "pred_na",
        na.rm = TRUE
      )[[".estimate"]],
      1
    ),
    round(
      hydroGOF::pbias(
        obs = ex_dat$obs[not_na],
        sim = ex_dat$pred[not_na]
      ),
      1
    )
  )
})

test_that("Result interpretation is returned", {
  ex_dat <- generate_numeric_test_data()

  expect_equal(
    pbias(
      ex_dat,
      truth = "obs",
      estimate = "pred",
      performance = TRUE
    )[[".estimate"]],
    "Poor"
  )
})
