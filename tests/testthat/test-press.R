test_that("press", {
  ex_dat <- generate_numeric_test_data()
  not_na <- !is.na(ex_dat$pred_na)

  expect_equal(
    press(
      ex_dat,
      truth = "obs",
      estimate = "pred",
      na_rm = FALSE
    )[[".estimate"]],
    sum((ex_dat$obs - ex_dat$pred)^2)
  )
  expect_equal(
    press(
      ex_dat,
      truth = obs,
      estimate = "pred_na",
      na_rm = TRUE
    )[[".estimate"]],
    sum((ex_dat$obs[not_na] - ex_dat$pred[not_na])^2)
  )
})
