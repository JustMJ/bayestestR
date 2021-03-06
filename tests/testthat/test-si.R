if (require("rstanarm") && require("bayestestR") && require("testthat")) {
  test_that("si.numeric", {
    set.seed(333)
    prior <- distribution_normal(1000, mean = 0, sd = 1)
    posterior <- distribution_normal(1000, mean = .5, sd = .3)

    res <- si(posterior, prior)
    expect_equal(res$CI_low, 0.03999124, tolerance = 0.02)
    expect_equal(res$CI_high, 1.053103, tolerance = 0.02)
    expect_s3_class(res, c("bayestestR_si"))

    res <- si(posterior, prior, BF = 3)
    expect_equal(res$CI_low, 0.333, tolerance = 0.02)
    expect_equal(res$CI_high, 0.759, tolerance = 0.02)

    res <- si(posterior, prior, BF = 100)
    expect_true(all(is.na(res$CI_low)))
    expect_true(all(is.na(res$CI_high)))

    res <- si(posterior, prior, BF = c(1 / 3, 1, 3))
    expect_equal(res$CI, c(1 / 3, 1, 3), tolerance = 0.02)
    expect_equal(res$CI_low, c(-0.119, 0.039, 0.333), tolerance = 0.02)
    expect_equal(res$CI_high, c(1.213, 1.053, 0.759), tolerance = 0.02)
  })

  test_that("si.rstanarm", {
    skip_on_cran()

    contrasts(sleep$group) <- contr.bayes # See vignette
    stan_model <- stan_lmer(extra ~ group + (1 | ID), data = sleep, refresh = 0)

    set.seed(333)
    stan_model_p <- update(stan_model, prior_PD = TRUE)
    res1 <- si(stan_model, stan_model_p, verbose = FALSE)

    set.seed(333)
    res2 <- si(stan_model, verbose = FALSE)

    expect_s3_class(res1, c("bayestestR_si"))
    expect_equal(res1, res2)
  })
}
