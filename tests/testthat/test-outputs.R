# Property-based testing
# https://www.etiennebacher.com/posts/2024-10-01-using-property-testing-in-r

# Tests to check that no matter the all sorts of numeric values
# are allowed in functions.

options(
  quickcheck.tests = 20L,
  quickcheck.shrinks = 10L,
  quickcheck.discards = 10L
)

test_that("GM", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_left_bounded(
      left = 1L,
      len = 100L,
      any_na = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, na_flag) {
      x <- gm_vec(truth = obs, na_rm = na_flag)
      df <- gm(data = data.frame(obs), truth = obs, na_rm = na_flag)

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("CV", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, na_flag) {
      x <- cv_vec(truth = obs, na_rm = na_flag)
      df <- cv(
        data = data.frame(obs),
        truth = obs,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("NSE", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- nse_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- nse(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("KGE", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- kge_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- kge(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("KGE'", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- kge2012_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- kge2012(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("KGElog", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_left_bounded(
      left = 1,
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_left_bounded(
      left = 1,
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- kgelog_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- kgelog(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("RMSE", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- rmse_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- rmse(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("MSE", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- mse_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- mse(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("pBIAS", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- pbias_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- pbias(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("PRESS", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- press_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- press(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})

test_that("SFE", {
  skip_if_not_installed("quickcheck")

  quickcheck::for_all(
    obs = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    sim = quickcheck::double_(
      len = 100L,
      any_na = TRUE,
      any_nan = TRUE,
      big_dbl = TRUE
    ),
    na_flag = quickcheck::logical_(len = 1L, any_na = FALSE),
    property = function(obs, sim, na_flag) {
      x <- sfe_vec(
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )
      df <- sfe(
        data = data.frame(obs, sim),
        truth = obs,
        estimate = sim,
        na_rm = na_flag
      )

      checkmate::expect_number(x, na.ok = TRUE)
      checkmate::expect_data_frame(
        df,
        types = c("numeric", "character"),
        min.rows = 1L
      )
    }
  )
})
