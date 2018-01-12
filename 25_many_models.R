
# 25 Many models ----------------------------------------------------------

library(tidyverse)
library(modelr)

library(gapminder)

gapminder

gapminder %>%
  ggplot() +
  geom_line(mapping = aes(x = year, y = lifeExp, group = country), alpha = 0.3)

nz <- filter(gapminder, country == "New Zealand")
ggplot(nz) +
  geom_line(aes(year, lifeExp))

nz_mod <- lm(lifeExp ~ year, data = nz)
nz %>%
  add_predictions(nz_mod) %>%
  ggplot() +
  geom_line(aes(year, pred))

nz %>%
  add_residuals(nz_mod) %>%
  ggplot() +
  geom_hline(yintercept = 0, colour = "white", size = 3) +
  geom_line(aes(year, resid))

# So we can do this pretty easily with one country, how do we fit this model, lifeExp ~ year
# to every country? We will be using a function and iteration! But we will be iterating
# across different observations of a dataset (by country): we need to create a nested
# dataframe:

by_country <- gapminder %>%
  group_by(country, continent) %>%
  nest()
by_country

# Compare this:
by_country$data[[1]]
# and this:
filter(gapminder, country == "Afghanistan")
# SAME!
# Now we can iterate easily using by_country:

country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

models <- map(by_country$data, country_model) # purrr::map() is very useful for iteration!!

by_country <- by_country %>%
  mutate(model = map(data, country_model))
by_country

by_country <- by_country %>%
  arrange(continent, country)

by_country <- by_country %>%
  mutate(
    resids = map2(data, model, add_residuals)
  )

# Now let us turn this data frame back to a non-'nested' version so we can easily plot using
# ggplot.

resids <- unnest(by_country, resids)

resids %>%
  ggplot() +
  geom_line(aes(x = year, y = resid, group = country), alpha = 0.5) +
  geom_smooth(aes(x = year, y = resid))

resids %>%
  ggplot(aes(year, resid, group = country)) +
  geom_line(alpha = 0.5) +
  geom_smooth(aes(group = NULL), se = F) +
  facet_wrap(~ continent)
# Very large residuals in Africa and some countries in Asia. The model is not fitting so well!

glance <- by_country %>%
  mutate(glance = map(model, broom::glance)) %>%
  unnest(glance, .drop = T)

glance %>%
  arrange(r.squared)

glance %>%
  ggplot() +
  geom_jitter(aes(x = continent, y = r.squared))

bad_fit <- filter(glance, r.squared <= 0.25)

gapminder %>%
  semi_join(bad_fit, by = "country") %>%
  ggplot(aes(year, lifeExp, colour = country)) +
  geom_line()
