
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


# 7.5 Covariation ---------------------------------------------------------

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>%
  group_by(cut) %>%
  count()

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip() +
  labs(x = "CLASS", y = "HWY")


# 7.5.1.1 Exercises -------------------------------------------------------

nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_cont = sched_hour + sched_min / 60
    ) %>%
  ggplot(mapping = aes(x = sched_dep_cont, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 0.5) +
  coord_cartesian(xlim = c(0, 24))

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 0.2)

ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = carat, y = ..density.., colour = cut))

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = reorder(cut, carat, FUN = median), y = carat)) +
  coord_flip()

summary(lm(carat ~ 0 + cut, data = diamonds))
summary(lm(price ~ 0 + cut, data = diamonds))

# Cut is negatively correlated with carat. Carat is positively correlated with
# price. Thus, cut is negatively correlated with price.

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = reorder(cut, price, FUN = median), y = price)) +
  coord_flip()
library(lvplot)
ggplot(data = diamonds) +
  geom_lv(mapping = aes(x = reorder(cut, price, FUN = median), y = price)) +
  coord_flip()

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_histogram(mapping = aes(fill = cut), binwidth = 400) +
  facet_wrap(~ cut, nrow = 5)
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut), size = 0.8)
ggplot(data = diamonds, mapping = aes(x = cut, y = price, fill = cut, colour = cut)) +
  geom_violin() +
  coord_flip()


# 7.5.2 Two categorical variables -----------------------------------------

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>%
  count(color, cut)

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

nycflights13::flights %>%
  group_by(dest, month) %>%
  summarise(mean_delay = mean(dep_delay, na.rm = T)) %>%
  ggplot(mapping = aes(x = month, y = dest)) +
  geom_tile(mapping = aes(fill = mean_delay)) +
  scale_fill_gradient(low = "green", high = "red")


# 7.5.3 Two continuous variables ------------------------------------------

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 0.01)

# Binning observations with one variable: hist and freqpoly
# Binning observations with two variables: ggplot2::bin2d and hexbin::hex!!!
ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price), bins = 40)

# We can also just bin one of our two cont variables:
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = T)

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))


# 7.5.3.1 Exercises -------------------------------------------------------

smaller <- diamonds %>%
  filter(carat < 3 & carat > 0)

ggplot(data = smaller, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut_width(carat, 1)))

ggplot(data = smaller, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut_number(carat, 5)))

ggplot(data = smaller, mapping = aes(x = carat, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut_width(price, 10000)))

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = x, y = y), alpha = 0.1) +
  coord_cartesian(xlim = c(4, 11), y = c(4, 11))


# 7.6 Patterns and models -------------------------------------------------

ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = log(carat), y = log(price)))

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = reorder(cut, price, FUN = median), y = price)) +
  coord_flip()
# From this it appears that the worse cut a diamond is, the higher in price it is!!
# But this is only because cut is correlated negatively with carat, which is
# positively correlated with price. So:

library(modelr)

model <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>%
  add_residuals(model) %>% # modelr funct that adds to dataframe the residuals of a lm
  mutate(resid = exp(resid))

ggplot(data = diamonds2) +
  geom_point(mapping = aes(x = carat, y = resid))

# The residuals are the 'leftover' unexplained variations in price:
ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = reorder(cut, resid, FUN = median), y = resid))
# And there we go! The relationship between cut and unexplained variation in price
# is positive as we expected!! Of course we can just use a multiple regression to 
# show the exact same thing:
summary(lm(log(price) ~ 0 + log(carat) + cut, data = diamonds))
