# Imported from {yardstick} package
# github.com/tidymodels/yardstick/blob/main/tests/testthat/helper-numeric.R

generate_numeric_test_data <- function() {
  set.seed(1812)
  out <- data.frame(obs = rnorm(1000))
  out$pred <- .2 + 1.1 * out$obs + rnorm(1000, sd = 0.5)
  out$pred_na <- out$pred
  ind <- (1:100) * 10
  out$pred_na[ind] <- NA
  out$rand <- sample(out$pred)
  out$rand_na <- out$rand
  out$rand_na[ind] <- NA
  out
}
