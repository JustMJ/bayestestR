if (require("testthat") && require("bayestestR") && require("rstanarm") && require("brms") && require("httr") && require("insight")) {
  test_that("describe_posterior", {
    set.seed(333)

    # Numeric
    x <- distribution_normal(1000)
    rez <- expect_warning(describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all", ci = 0.89))

    printed <- format(rez)
    expect_true("89% CI" %in% names(printed))

    expect_equal(dim(rez), c(1, 19))
    expect_equal(colnames(rez), c(
      "Parameter", "Median", "MAD", "Mean", "SD", "MAP", "CI", "CI_low",
      "CI_high", "p_map", "pd", "p_ROPE", "ps", "ROPE_CI", "ROPE_low",
      "ROPE_high", "ROPE_Percentage", "ROPE_Equivalence", "BF"
    ))
    rez <- expect_warning(describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all", ci = c(0.8, 0.9)))
    expect_equal(dim(rez), c(2, 19))
    rez <- describe_posterior(x, centrality = NULL, dispersion = TRUE, test = NULL, ci_method = "quantile")
    expect_equal(dim(rez), c(1, 4))

    # Dataframes
    x <- data.frame(replicate(4, rnorm(100)))
    rez <- expect_warning(describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all"))
    expect_equal(dim(rez), c(4, 19))
    rez <- expect_warning(describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all", ci = c(0.8, 0.9)))
    expect_equal(dim(rez), c(8, 19))
    rez <- describe_posterior(x, centrality = NULL, dispersion = TRUE, test = NULL, ci_method = "quantile")
    expect_equal(dim(rez), c(4, 4))
  })


  .runThisTest <- Sys.getenv("RunAllbayestestRTests") == "yes"
  if (.runThisTest && Sys.info()["sysname"] != "Darwin") {
    test_that("describe_posterior", {
      set.seed(333)
      # Rstanarm
      x <- rstanarm::stan_glm(mpg ~ wt, data = mtcars, refresh = 0, iter = 500)
      rez <- describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all")
      expect_equal(dim(rez), c(2, 21))
      expect_equal(colnames(rez), c(
        "Parameter", "Median", "MAD", "Mean", "SD", "MAP", "CI", "CI_low",
        "CI_high", "p_MAP", "pd", "p_ROPE", "ps", "ROPE_CI", "ROPE_low",
        "ROPE_high", "ROPE_Percentage", "ROPE_Equivalence", "BF", "Rhat",
        "ESS"
      ))
      rez <- describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all", ci = c(0.8, 0.9))
      expect_equal(dim(rez), c(4, 21))
      rez <- describe_posterior(x, centrality = NULL, dispersion = TRUE, test = NULL, ci_method = "quantile", diagnostic = NULL, priors = FALSE)
      expect_equal(dim(rez), c(2, 4))

      # Brms
      x <- brms::brm(mpg ~ wt + (1 | cyl) + (1 + wt | gear), data = mtcars, refresh = 0)
      rez <- describe_posterior(x, centrality = "all", dispersion = TRUE, ci = c(0.8, 0.9))
      expect_equal(dim(rez), c(4, 16))
      expect_equal(colnames(rez), c(
        "Parameter", "Median", "MAD", "Mean", "SD", "MAP", "CI", "CI_low",
        "CI_high", "pd", "ROPE_CI", "ROPE_low", "ROPE_high", "ROPE_Percentage",
        "Rhat", "ESS"
      ))
      rez <- describe_posterior(x, centrality = NULL, dispersion = TRUE, test = NULL, ci_method = "quantile", diagnostic = NULL)
      expect_equal(dim(rez), c(2, 4))

      # With non standard algorithms
      model <- rstanarm::stan_glm(mpg ~ drat, data = mtcars, algorithm = "meanfield", refresh = 0)
      expect_equal(nrow(describe_posterior(model)), 2)
      model <- brms::brm(mpg ~ drat, data = mtcars, chains = 2, algorithm = "meanfield", refresh = 0)
      expect_equal(nrow(describe_posterior(model)), 2)
      model <- rstanarm::stan_glm(mpg ~ drat, data = mtcars, algorithm = "optimizing", refresh = 0)
      expect_equal(nrow(describe_posterior(model)), 2)
      model <- rstanarm::stan_glm(mpg ~ drat, data = mtcars, algorithm = "fullrank", refresh = 0)
      expect_equal(nrow(describe_posterior(model)), 2)
      # model <- brms::brm(mpg ~ drat, data = mtcars, chains=2, algorithm="fullrank", refresh=0)
      # expect_equal(nrow(describe_posterior(model)), 2)

      # BayesFactor
      # library(BayesFactor)
      # x <- BayesFactor::ttestBF(x = rnorm(100, 1, 1))
      # rez <- describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all")
      # expect_equal(dim(rez), c(4, 16))
      # rez <- describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all", ci = c(0.8, 0.9))
      # expect_equal(dim(rez), c(8, 16))
      # rez <- describe_posterior(x, centrality = NULL, dispersion = TRUE, test = NULL, ci_method="quantile")
      # expect_equal(dim(rez), c(4, 4))
    })

    if (require("insight")) {
      m <- insight::download_model("stanreg_merMod_5")
      p <- insight::get_parameters(m, effects = "all")

      test_that("describe_posterior", {
        expect_equal(
          describe_posterior(m, effects = "all")$Median,
          describe_posterior(p)$Median,
          tolerance = 1e-3
        )
      })

      m <- insight::download_model("brms_zi_3")
      p <- insight::get_parameters(m, effects = "all", component = "all")

      test_that("describe_posterior", {
        expect_equal(
          describe_posterior(m, effects = "all", component = "all")$Median,
          describe_posterior(p)$Median,
          tolerance = 1e-3
        )
      })
    }


    test_that("describe_posterior w/ BF+SI", {
      skip_on_cran()

      x <- insight::download_model("stanreg_lm_1")
      set.seed(555)
      rez <- describe_posterior(x, ci_method = "SI", test = "bf")


      # test si
      set.seed(555)
      rez_si <- si(x)
      expect_equal(rez$CI_low, rez_si$CI_low, tolerance = 0.1)
      expect_equal(rez$CI_high, rez_si$CI_high, tolerance = 0.1)

      # test BF
      set.seed(555)
      rez_bf <- bayesfactor_parameters(x)
      expect_equal(rez$BF, rez_bf$BF, tolerance = 0.1)
    })
  }
}
