
# 23 Model basics ---------------------------------------------------------

library(tidyverse)
library(modelr)
options(na.action = na.warn)

sim1

ggplot(sim1) +
  geom_point(mapping = aes(x = x, y = y))

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)
ggplot(sim1) +
  geom_point(mapping = aes(x = x, y = y)) +
  geom_abline(mapping = aes(intercept = a1, slope = a2), data = models, alpha = 0.25)

# creating an R function for the fitted line:
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
# test
model1(c(1, 2.2), sim1)

# Given this family of models, or this specification of a regression model, we want to find
# the best specific model. That is, we want to find a specific line that, by some criteria,
# is the 'best' for predicting values of y based on provided values of x.
# In OLS estimation, we want to minimise the 'distance' between the actual values and the
# fitted values, as measured by the sum of squared deviations: SSE (sum of squared 'errors',
# which would more correctly be called residuals).
# Here, Hadley wants us to measure the 'deviation' using RMSD or Root-mean-square deviation,
# which we then probably try to minimise:


rms_dev <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}

ols <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sum(diff ^ 2)
}

sim1_dist <- function(a1, a2) {
  rms_dev(c(a1, a2), sim1)
}

sim1_dist_ols <- function(a1, a2) {
  ols(c(a1, a2), sim1)
}

models <- models %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist), dist_ols = purrr::map2_dbl(a1, a2, sim1_dist_ols))

ggplot(data = sim1) +
  geom_point(mapping = aes(x = x, y = y), colour = "red") +
  geom_abline(
    data = filter(models, rank(dist) <= 10), 
    mapping = aes(intercept = a1, slope = a2, colour = -dist),
    size = 1
    )

ggplot(data = models) +
  geom_point(data = filter(models, rank(dist) <= 10), aes(x = a1, y = a2), colour = "red", size = 3) +
  geom_point(aes(x = a1, y = a2, colour = -dist))
 
grid <- expand.grid(
  a1 = seq(-5, 20, length = 50),
  a2 = seq(1, 3, length = 50)
) %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>%
  ggplot(mapping = aes(x = a1, y = a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), colour = "red", size = 4) +
  geom_point(mapping = aes(colour = -dist))

ggplot(data = sim1, mapping = aes(x = x, y = y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    data = filter(grid, rank(dist) <= 10),
    mapping = aes(intercept = a1, slope = a2, colour = -dist)
  )

best <- optim(c(0, 0), rms_dev, data = sim1)
best$par

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)


# 23.3 Visualising models -------------------------------------------------

grid <- sim1 %>%
  data_grid(x) %>%
  add_predictions(sim1_mod)
ggplot(data = sim1) +
  geom_point(mapping = aes(x = x, y = y)) +
  geom_line(data = grid, mapping = aes(x = x, y = pred), colour = "red", size = 1)

sim1 <- sim1 %>%
  add_residuals(sim1_mod)
ggplot(data = sim1) +
  geom_freqpoly(mapping = aes(x = resid), binwidth = 0.5)
ggplot(data = sim1) +
  geom_ref_line(h = 0) +
  geom_point(mapping = aes(x = x, y = resid))

sim1_loess <- loess(y ~ x, data = sim1)
grid1 <- sim1 %>%
  data_grid(x) %>%
  add_predictions(sim1_loess)
ggplot(data = sim1) +
  geom_point(mapping = aes(x = x, y = y)) +
  geom_line(data = grid1, mapping = aes(x = x, y = pred), colour = "red", size = 1)

sim1_loess_resid <- sim1 %>%
  add_residuals(sim1_loess)
ggplot(data = sim1_loess_resid) +
  geom_ref_line(h = 0) +
  geom_point(mapping = aes(x = x, y = resid))

