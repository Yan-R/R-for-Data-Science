
# 7 Exploratory data analysis ---------------------------------------------

library(tidyverse)

smaller <- diamonds %>%
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.05)

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

ggplot(data = diamonds, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01) +
  coord_cartesian(ylim = c(0, 100))

ggplot(data = diamonds, mapping = aes(x = y)) +
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

unusual_values <- diamonds %>%
  filter(y < 3 | y > 20) %>%
  select(price, x, y, z) %>%
  arrange(y)


# 7.3.4 Exercises ---------------------------------------------------------

rm.outlier <- diamonds %>%
  filter(!(y < 3 | y > 20))

ggplot(data = rm.outlier) +
  geom_histogram(mapping = aes(x = x)) +
  coord_cartesian(xlim = c(0, 11))
ggplot(data = rm.outlier) +
  geom_histogram(mapping = aes(x = y)) +
  coord_cartesian(xlim = c(0, 11))
ggplot(data = rm.outlier) +
  geom_histogram(mapping = aes(x = z)) +
  coord_cartesian(xlim = c(0, 11))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 50)

diamonds %>%
  filter(carat == 0.99)
diamonds %>%
  filter(carat == 1)

ggplot(data = rm.outlier) +
  geom_histogram(mapping = aes(x = x)) +
  coord_cartesian(xlim = c(0, 7.1))


# 7.4 Missing values ------------------------------------------------------

diamonds2 <- diamonds %>%
  filter(between(y, 3, 20))

diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>%
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 0.25)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = x), binwidth = 0.01)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = x))
