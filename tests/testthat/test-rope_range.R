if (require("brms", quietly = TRUE)) {
  test_that("rope_range", {
    model <- brm(mpg ~ wt + gear, data = mtcars, iter = 300)

    testthat::expect_equal(
      rope_range(model),
      c(-0.6026948, 0.6026948),
      tolerance = 0.01
    )
  })

  test_that("rope_range (multivariate)", {
    model <- brm(mvbind(mpg, disp) ~ wt + gear, data = mtcars, iter = 300)

    testthat::expect_equal(
      rope_range(model),
      list(
        mpg = c(-0.602694, 0.602694),
        disp = c(-12.393869, 12.393869)
      ),
      tolerance = 0.01
    )
  })
}
