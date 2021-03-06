if (require("brms") && require("testthat") && require("insight") && require("httr")) {
  test_that("brms", {
    skip_on_cran()

    set.seed(333)
    model <- insight::download_model("brms_mixed_1")

    expect_s3_class(hdi(model), "data.frame")
    expect_s3_class(ci(model), "data.frame")
    expect_s3_class(rope(model), "data.frame")
    # expect_true("equivalence_test" %in% class(equivalence_test(model)))
    expect_s3_class(map_estimate(model), "data.frame")
    expect_s3_class(p_map(model), "data.frame")
    expect_s3_class(mhdior(model), "data.frame")
    expect_s3_class(p_direction(model), "data.frame")

    expect_equal(colnames(hdi(model)), c("Parameter", "CI", "CI_low", "CI_high", "Effects", "Component"))
    expect_equal(colnames(hdi(model, effects = "all")), c("Parameter", "CI", "CI_low", "CI_high", "Effects", "Component"))
    # expect_equal(nrow(equivalence_test(model)), 2)

    out <- describe_posterior(model, effects = "all", components = "all", centrality = "mean")
    s <- summary(model)
    expect_identical(colnames(out), c(
      "Parameter", "Effects", "Mean", "CI", "CI_low", "CI_high",
      "pd", "ROPE_CI", "ROPE_low", "ROPE_high", "ROPE_Percentage",
      "Rhat", "ESS"
    ))
    expect_equal(as.vector(s$fixed[, 1, drop = TRUE]), out$Mean[1:2], tolerance = 1e-3)
    expect_equal(as.vector(s$fixed[, 5, drop = TRUE]), out$Rhat[1:2], tolerance = 1e-1)
    expect_equal(as.vector(s$random$cyl[, 1, drop = TRUE]), out$Mean[12], tolerance = 1e-3)
    expect_equal(as.vector(s$random$gear[, 1, drop = TRUE]), out$Mean[13:15], tolerance = 1e-3)
  })

  test_that("brms", {
    # skip_on_travis()
    skip_on_cran()

    set.seed(333)
    model <- insight::download_model("brms_1")

    out <- describe_posterior(model, effects = "all", components = "all", centrality = "mean")
    s <- summary(model)
    expect_identical(colnames(out), c(
      "Parameter", "Mean", "CI", "CI_low", "CI_high", "pd", "ROPE_CI",
      "ROPE_low", "ROPE_high", "ROPE_Percentage", "Rhat", "ESS"
    ))
    expect_equal(as.vector(s$fixed[, 1, drop = TRUE]), out$Mean[1:3], tolerance = 1e-3)
    expect_equal(as.vector(s$fixed[, 5, drop = TRUE]), out$Rhat[1:3], tolerance = 1e-1)
  })

  test_that("brms", {
    # skip_on_travis()
    skip_on_cran()

    set.seed(333)
    model <- insight::download_model("brms_mv_2")

    out <- describe_posterior(model, effects = "all", components = "all", centrality = "mean", test = NULL)
    s <- summary(model)
    expect_identical(colnames(out), c(
      "Parameter", "Effects", "Mean", "CI", "CI_low", "CI_high",
      "Rhat", "ESS"
    ))
    expect_equal(as.vector(s$fixed[, 1, drop = TRUE]), out$Mean[c(1, 11, 2:5, 12:14)], tolerance = 1e-3)
    expect_equal(as.vector(s$fixed[, 5, drop = TRUE]), out$Rhat[c(1, 11, 2:5, 12:14)], tolerance = 1e-1)
  })

  test_that("brms", {
    # skip_on_travis()
    skip_on_cran()

    set.seed(333)
    model <- insight::download_model("brms_2")

    out <- describe_posterior(model, effects = "all", components = "all", centrality = "mean", test = NULL)
    s <- summary(model)
    expect_equal(as.vector(s$fixed[, 1, drop = TRUE]), out$Mean, tolerance = 1e-3)
    expect_equal(as.vector(s$fixed[, 5, drop = TRUE]), out$Rhat, tolerance = 1e-1)
  })
}
