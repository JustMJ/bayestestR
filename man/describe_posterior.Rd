% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/describe_posterior.R
\name{describe_posterior}
\alias{describe_posterior}
\alias{describe_posterior.numeric}
\alias{describe_posterior.stanreg}
\alias{describe_posterior.stanmvreg}
\alias{describe_posterior.MCMCglmm}
\alias{describe_posterior.brmsfit}
\alias{describe_posterior.BFBayesFactor}
\title{Describe Posterior Distributions}
\usage{
describe_posterior(
  posteriors,
  centrality = "median",
  dispersion = FALSE,
  ci = 0.89,
  ci_method = "hdi",
  test = c("p_direction", "rope"),
  rope_range = "default",
  rope_ci = 0.89,
  ...
)

\method{describe_posterior}{numeric}(
  posteriors,
  centrality = "median",
  dispersion = FALSE,
  ci = 0.89,
  ci_method = "hdi",
  test = c("p_direction", "rope"),
  rope_range = "default",
  rope_ci = 0.89,
  bf_prior = NULL,
  BF = 1,
  ...
)

\method{describe_posterior}{stanreg}(
  posteriors,
  centrality = "median",
  dispersion = FALSE,
  ci = 0.89,
  ci_method = "hdi",
  test = c("p_direction", "rope"),
  rope_range = "default",
  rope_ci = 0.89,
  bf_prior = NULL,
  diagnostic = c("ESS", "Rhat"),
  priors = FALSE,
  effects = c("fixed", "random", "all"),
  component = c("location", "all", "conditional", "smooth_terms", "sigma",
    "distributional", "auxiliary"),
  parameters = NULL,
  BF = 1,
  ...
)

\method{describe_posterior}{stanmvreg}(
  posteriors,
  centrality = "median",
  dispersion = FALSE,
  ci = 0.89,
  ci_method = "hdi",
  test = "p_direction",
  rope_range = "default",
  rope_ci = 0.89,
  bf_prior = NULL,
  diagnostic = c("ESS", "Rhat"),
  priors = FALSE,
  effects = c("fixed", "random", "all"),
  component = c("location", "all", "conditional", "smooth_terms", "sigma",
    "distributional", "auxiliary"),
  parameters = NULL,
  ...
)

\method{describe_posterior}{MCMCglmm}(
  posteriors,
  centrality = "median",
  dispersion = FALSE,
  ci = 0.89,
  ci_method = "hdi",
  test = c("p_direction", "rope"),
  rope_range = "default",
  rope_ci = 0.89,
  diagnostic = "ESS",
  parameters = NULL,
  ...
)

\method{describe_posterior}{brmsfit}(
  posteriors,
  centrality = "median",
  dispersion = FALSE,
  ci = 0.89,
  ci_method = "hdi",
  test = c("p_direction", "rope"),
  rope_range = "default",
  rope_ci = 0.89,
  bf_prior = NULL,
  diagnostic = c("ESS", "Rhat"),
  effects = c("fixed", "random", "all"),
  component = c("conditional", "zi", "zero_inflated", "all", "location",
    "distributional", "auxiliary"),
  parameters = NULL,
  BF = 1,
  ...
)

\method{describe_posterior}{BFBayesFactor}(
  posteriors,
  centrality = "median",
  dispersion = FALSE,
  ci = 0.89,
  ci_method = "hdi",
  test = c("p_direction", "rope", "bf"),
  rope_range = "default",
  rope_ci = 0.89,
  priors = TRUE,
  ...
)
}
\arguments{
\item{posteriors}{A vector, data frame or model of posterior draws.}

\item{centrality}{The point-estimates (centrality indices) to compute.  Character (vector) or list with one or more of these options: \code{"median"}, \code{"mean"}, \code{"MAP"} or \code{"all"}.}

\item{dispersion}{Logical, if \code{TRUE}, computes indices of dispersion related to the estimate(s) (\code{SD} and \code{MAD} for \code{mean} and \code{median}, respectively).}

\item{ci}{Value or vector of probability of the CI (between 0 and 1)
to be estimated. Default to \code{.89} (89\%) for Bayesian models and \code{.95} (95\%) for frequentist models.}

\item{ci_method}{The type of index used for Credible Interval. Can be
\code{"HDI"} (default, see \code{\link[bayestestR:hdi]{hdi}}), \code{"ETI"}
(see \code{\link[bayestestR:eti]{eti}}) or \code{"SI"}
(see \code{\link[bayestestR:si]{si}}).}

\item{test}{The indices of effect existence to compute. Character (vector) or
list with one or more of these options: \code{"p_direction"} (or \code{"pd"}),
\code{"rope"}, \code{"p_map"}, \code{"equivalence_test"} (or \code{"equitest"}),
\code{"bayesfactor"} (or \code{"bf"}) or \code{"all"} to compute all tests.
For each "test", the corresponding \pkg{bayestestR} function is called
(e.g. \code{\link[bayestestR:rope]{rope}} or \code{\link[bayestestR:p_direction]{p_direction}}) and its results
included in the summary output.}

\item{rope_range}{ROPE's lower and higher bounds. Should be a list of two
values (e.g., \code{c(-0.1, 0.1)}) or \code{"default"}. If \code{"default"},
the bounds are set to \code{x +- 0.1*SD(response)}.}

\item{rope_ci}{The Credible Interval (CI) probability, corresponding to the
proportion of HDI, to use for the percentage in ROPE.}

\item{...}{Additional arguments to be passed to or from methods.}

\item{bf_prior}{Distribution representing a prior for the computation of Bayes factors / SI. Used if the input is a posterior, otherwise (in the case of models) ignored.}

\item{BF}{The amount of support required to be included in the support interval.}

\item{diagnostic}{Diagnostic metrics to compute.  Character (vector) or list with one or more of these options: \code{"ESS"}, \code{"Rhat"}, \code{"MCSE"} or \code{"all"}.}

\item{priors}{Add the prior used for each parameter.}

\item{effects}{Should results for fixed effects, random effects or both be returned?
Only applies to mixed models. May be abbreviated.}

\item{component}{Should results for all parameters, parameters for the conditional model
or the zero-inflated part of the model be returned? May be abbreviated. Only
applies to \pkg{brms}-models.}

\item{parameters}{Regular expression pattern that describes the parameters that
should be returned. Meta-parameters (like \code{lp__} or \code{prior_}) are
filtered by default, so only parameters that typically appear in the
\code{summary()} are returned. Use \code{parameters} to select specific parameters
for the output.}
}
\description{
Compute indices relevant to describe and characterize the posterior distributions.
}
\details{
One or more components of point estimates (like posterior mean or median),
  intervals and tests can be omitted from the summary output by setting the
  related argument to \code{NULL}. For example, \code{test = NULL} and
  \code{centrality = NULL} would only return the HDI (or CI).
}
\examples{
library(bayestestR)

if (require("logspline")) {
  x <- rnorm(1000)
  describe_posterior(x)
  describe_posterior(x, centrality = "all", dispersion = TRUE, test = "all")
  describe_posterior(x, ci = c(0.80, 0.90))

  df <- data.frame(replicate(4, rnorm(100)))
  describe_posterior(df)
  describe_posterior(df, centrality = "all", dispersion = TRUE, test = "all")
  describe_posterior(df, ci = c(0.80, 0.90))
}
\dontrun{
# rstanarm models
# -----------------------------------------------
if (require("rstanarm") && require("emmeans")) {
  model <- stan_glm(mpg ~ wt + gear, data = mtcars, chains = 2, iter = 200, refresh = 0)
  describe_posterior(model)
  describe_posterior(model, centrality = "all", dispersion = TRUE, test = "all")
  describe_posterior(model, ci = c(0.80, 0.90))

  # emmeans estimates
  # -----------------------------------------------
  describe_posterior(emtrends(model, ~1, "wt"))
}

# brms models
# -----------------------------------------------
if (require("brms")) {
  model <- brms::brm(mpg ~ wt + cyl, data = mtcars)
  describe_posterior(model)
  describe_posterior(model, centrality = "all", dispersion = TRUE, test = "all")
  describe_posterior(model, ci = c(0.80, 0.90))
}

# BayesFactor objects
# -----------------------------------------------
if (require("BayesFactor")) {
  bf <- ttestBF(x = rnorm(100, 1, 1))
  describe_posterior(bf)
  describe_posterior(bf, centrality = "all", dispersion = TRUE, test = "all")
  describe_posterior(bf, ci = c(0.80, 0.90))
}
}
}
\references{
\itemize{
  \item \href{https://easystats.github.io/bayestestR/articles/indicesEstimationComparison.html}{Comparison of Point-Estimates}
  \item \href{https://easystats.github.io/bayestestR/articles/region_of_practical_equivalence.html}{Region of Practical Equivalence (ROPE)}
  \item \href{https://easystats.github.io/bayestestR/articles/bayes_factors.html}{Bayes factors}
}
}
