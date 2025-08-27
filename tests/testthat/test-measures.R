test_that("Negative values are not allowed in GM", {
  x <- rnorm(100)

  expect_error(gm_vec(x))
})
