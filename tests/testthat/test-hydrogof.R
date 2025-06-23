# Property-based testing
# https://www.etiennebacher.com/posts/2024-10-01-using-property-testing-in-r

options(
  quickcheck.tests = 20L,
  quickcheck.shrinks = 10L,
  quickcheck.discards = 10L
)

test_that("nse", {
  skip_if_not_installed("quickcheck")
  skip_if_not_installed("hydroGOF")

  quickcheck::for_all(
    obs = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    sim = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    property = function(obs, sim) {
      new <- nse_vec(truth = obs, estimate = sim, na_rm = TRUE)
      old <- hydroGOF::NSE(sim = sim, obs = obs, na.rm = TRUE)

      expect_equal(new, old)
    }
  )
})

test_that("kge", {
  skip_if_not_installed("quickcheck")
  skip_if_not_installed("hydroGOF")

  quickcheck::for_all(
    obs = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    sim = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    property = function(obs, sim) {
      new <- kge_vec(truth = obs, estimate = sim, na_rm = TRUE)
      old <- hydroGOF::KGE(sim = sim, obs = obs, na.rm = TRUE)

      expect_equal(new, old)
    }
  )
})

test_that("pbias", {
  skip_if_not_installed("quickcheck")
  skip_if_not_installed("hydroGOF")

  quickcheck::for_all(
    obs = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    sim = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    property = function(obs, sim) {
      new <- pbias_vec(truth = obs, estimate = sim, na_rm = TRUE)
      old <- hydroGOF::pbias(sim = sim, obs = obs, na.rm = TRUE, dec = 9)

      expect_equal(new, old)
    }
  )
})

test_that("mse", {
  skip_if_not_installed("quickcheck")
  skip_if_not_installed("hydroGOF")

  quickcheck::for_all(
    obs = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    sim = quickcheck::double_bounded(
      left = -1000,
      right = 1000,
      len = 50,
      any_na = TRUE
    ),
    property = function(obs, sim) {
      new <- mse_vec(truth = obs, estimate = sim, na_rm = TRUE)
      old <- hydroGOF::mse(sim = sim, obs = obs, na.rm = TRUE)

      expect_equal(new, old)
    }
  )
})
