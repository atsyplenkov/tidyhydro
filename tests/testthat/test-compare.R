# Property-based testing
# https://www.etiennebacher.com/posts/2024-10-01-using-property-testing-in-r

options(
  quickcheck.tests = 50L,
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

      new_na <-
        replace(
          new,
          any(is.nan(new), is.infinite(new), is.na(new)),
          NA_real_
        )
      old_na <-
        replace(
          old,
          any(is.nan(old), is.infinite(old), is.na(old)),
          NA_real_
        )

      expect_equal(new_na, old_na, tolerance = 1e-6)
    }
  )
})
