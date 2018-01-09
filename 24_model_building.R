
# 24 Model building -------------------------------------------------------

library(tidyverse)
library(modelr)
library(nycflights13)
library(lubridate)

ggplot(diamonds, aes(cut, price)) + geom_boxplot()
ggplot(diamonds, aes(color, price)) + geom_boxplot()
ggplot(diamonds, aes(clarity, price)) + geom_boxplot()
ggplot(diamonds, aes(carat)) + geom_freqpoly()
ggplot(diamonds) + geom_bin2d(mapping = aes(x = carat, y = price), bins = 50)

diamonds2 <- diamonds %>%
  filter(carat <= 2.5) %>%
  mutate(lprice = log2(price), lcarat = log2(carat))
ggplot(data = diamonds2) +
  geom_bin2d(mapping = aes(x = lcarat, y = lprice), bins = 50)

mod_diamond <- lm(lprice~lcarat, data = diamonds2)

grid <- diamonds2 %>%
  data_grid(carat = seq_range(carat, 20)) %>%
  mutate(lcarat = log2(carat)) %>%
  add_predictions(mod_diamond, "lprice") %>%
  mutate(price = 2 ^ lprice)

ggplot(data = diamonds2) +
  geom_bin2d(mapping = aes(x = carat, y = price), bins = 50) +
  geom_line(data = grid, mapping = aes(x = carat, y = price), colour = "red", size = 1)

diamonds2 <- diamonds2 %>%
  add_residuals(mod_diamond, "lresid")
ggplot(diamonds2, aes(lcarat, lresid)) +
  geom_bin2d(bins = 50)

ggplot(diamonds2, aes(cut, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(color, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(clarity, lresid)) + geom_boxplot()


# 24.3 What affects the number of daily flights? --------------------------

daily <- flights %>%
  mutate(date = make_date(year, month, day)) %>%
  group_by(date) %>%
  summarise(n = n())

ggplot(daily) +
  geom_line(aes(x = date, y = n))

# Clearly there is some day of the week effect:

daily <- daily %>%
  mutate(wday = wday(date, label = T))
ggplot(daily, aes(wday, n)) +
  geom_boxplot()

mod <- lm(n ~ wday, data = daily)

grid <- daily %>%
  data_grid(wday) %>%
  add_predictions(mod, "n")

daily %>%
  group_by(wday) %>%
  summarise(mean = mean(n))

ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid, colour = "red", size = 4)

daily <- daily %>%
  add_residuals(mod)
ggplot(daily) +
  geom_ref_line(h = 0) +
  geom_line(aes(date, resid))

ggplot(daily) +
  geom_ref_line(h = 0) +
  geom_line(aes(date, resid, colour = wday))

daily %>%
  filter(wday == "Sat") %>%
  ggplot(aes(date, n)) +
  geom_point() +
  geom_line() +
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

term <- function(date) {
  cut(date, 
      breaks = ymd(20130101, 20130605, 20130825, 20140101),
      labels = c("spring", "summer", "fall") 
  )
}
daily <- daily %>% 
  mutate(term = term(date))
daily %>% 
  filter(wday == "Sat") %>% 
  ggplot(aes(date, n, colour = term)) +
  geom_point(alpha = 1/3) + 
  geom_line() +
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")
