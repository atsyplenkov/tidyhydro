# Property-based testing
# https://www.etiennebacher.com/posts/2024-10-01-using-property-testing-in-r

options(
  quickcheck.tests = 20L,
  quickcheck.shrinks = 10L,
  quickcheck.discards = 10L
)

test_that("nse", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::any_atomic(any_na = TRUE),
    sim = quickcheck::any_atomic(any_na = TRUE),
    na_flag = quickcheck::logical_(any_na = FALSE),
    property = function(obs, sim, na_flag) {
      suppressWarnings(
        try(
          nse_vec(truth = obs, estimate = sim, na_rm = na_flag),
          silent = TRUE
        )
      )
      expect_true(TRUE)
    }
  )
})

test_that("mse", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::any_atomic(any_na = TRUE),
    sim = quickcheck::any_atomic(any_na = TRUE),
    na_flag = quickcheck::logical_(any_na = FALSE),
    property = function(obs, sim, na_flag) {
      suppressWarnings(
        try(
          mse_vec(truth = obs, estimate = sim, na_rm = na_flag),
          silent = TRUE
        )
      )
      expect_true(TRUE)
    }
  )
})

test_that("kge", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::any_atomic(any_na = TRUE),
    sim = quickcheck::any_atomic(any_na = TRUE),
    na_flag = quickcheck::logical_(any_na = FALSE),
    property = function(obs, sim, na_flag) {
      suppressWarnings(
        try(
          kge_vec(truth = obs, estimate = sim, na_rm = na_flag),
          silent = TRUE
        )
      )
      expect_true(TRUE)
    }
  )
})

test_that("kge2012", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::any_atomic(any_na = TRUE),
    sim = quickcheck::any_atomic(any_na = TRUE),
    na_flag = quickcheck::logical_(any_na = FALSE),
    property = function(obs, sim, na_flag) {
      suppressWarnings(
        try(
          kge2012_vec(truth = obs, estimate = sim, na_rm = na_flag),
          silent = TRUE
        )
      )
      expect_true(TRUE)
    }
  )
})

test_that("pbias", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::any_atomic(any_na = TRUE),
    sim = quickcheck::any_atomic(any_na = TRUE),
    na_flag = quickcheck::logical_(any_na = FALSE),
    property = function(obs, sim, na_flag) {
      suppressWarnings(
        try(
          pbias_vec(truth = obs, estimate = sim, na_rm = na_flag),
          silent = TRUE
        )
      )
      expect_true(TRUE)
    }
  )
})

test_that("sfe", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::any_atomic(any_na = TRUE),
    sim = quickcheck::any_atomic(any_na = TRUE),
    na_flag = quickcheck::logical_(any_na = FALSE),
    property = function(obs, sim, na_flag) {
      suppressWarnings(
        try(
          sfe_vec(truth = obs, estimate = sim, na_rm = na_flag),
          silent = TRUE
        )
      )
      expect_true(TRUE)
    }
  )
})

test_that("press", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::any_atomic(any_na = TRUE),
    sim = quickcheck::any_atomic(any_na = TRUE),
    na_flag = quickcheck::logical_(any_na = FALSE),
    property = function(obs, sim, na_flag) {
      suppressWarnings(
        try(
          press_vec(truth = obs, estimate = sim, na_rm = na_flag),
          silent = TRUE
        )
      )
      expect_true(TRUE)
    }
  )
})
