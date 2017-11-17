
# 5 Data transformation ---------------------------------------------------

library(nycflights13)
library(tidyverse)


# 5.2 Filter rows with filter() -------------------------------------------

(jan1 <- filter(flights, month == 1, day == 1))
(novdec <- filter(flights, month == 11 | month == 12))
(novdec <- filter(flights, month %in% c(11, 12)))
(nodelay <- filter(flights, !(arr_delay >= 120 | dep_delay >= 120)))
(nodelay <- filter(flights, arr_delay < 120 & dep_delay < 120))


# 5.2.4 Exercises ---------------------------------------------------------

(filter(flights, arr_delay >= 120))
(filter(flights, dest == "IAH" | dest == "HOU"))
(filter(flights, carrier == "UA" | carrier == "AA" | carrier == "DL"))
(filter(flights, month == 6 | month == 7 | month == 8))
(filter(flights, arr_delay > 120 & !(dep_delay > 0)))
(filter(flights, dep_delay >= 60 & dep_delay-arr_delay > 30))
(filter(flights, dep_time >= 0 & dep_time <= 600))
(filter(flights, (between(dep_time, 0, 600))))

(filter(flights, is.na(dep_time)))


# 5.3 Arrange rows with arrange() -----------------------------------------

(arrange(flights, year, month, day, arr_time))
(arrange(flights, desc(arr_delay)))


# 5.3.1 Exercises ---------------------------------------------------------

(arrange(flights, !is.na(dep_time)))
(arrange(flights, desc(arr_delay)))
(arrange(flights, dep_time))
(arrange(flights, air_time))
(arrange(flights, desc(air_time)))


# 5.4 Select columns with select() ----------------------------------------

(select(flights, year, month, day))
(select(flights, year:day))
(select(flights, -(year:day)))

(select(flights, starts_with("arr")))
(select(flights, year:day, ends_with("delay")))
(select(flights, contains("arr"), -carrier))
(select(flights, matches("arr")))

(rename(flights, YEAR_BOIII = year))

(select(flights, dep_delay, arr_delay, everything()))


# 5.4.1 Exercises ---------------------------------------------------------

(select(flights, year, year, year))
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
(select(flights, one_of(vars)))
(select(flights, contains("TiMe")))


# 5.5 Add new variables with mutate() -------------------------------------

flights_sml <- select(flights, year:day, ends_with("delay"), 
                      distance, air_time
                      )
(mutate(flights_sml, time_gain = dep_delay - arr_delay, 
        speed = (distance / air_time) * 60
        ))
(mutate(flights_sml, time_gain = dep_delay - arr_delay,
        hours = air_time / 60,
        gain_per_hour = time_gain / hours
        ))
(transmute(flights, time_gain = dep_delay - arr_delay,
           speed = (distance / air_time) * 60))


# 5.5.1 Useful creation functions -----------------------------------------

(transmute(flights, hours = air_time / 60))
no.na <- filter(flights, !is.na(dep_delay))
(transmute(no.na, dep_delay, 
           dep_delay.dev = dep_delay - mean(dep_delay)
           ))
# Modular arithmetic: integer division and remainders
(transmute(flights, dep_time, hour = dep_time %/% 100,
           minute = dep_time %% 100
           ))
# lags and leads for running differences
(transmute(filter(flights, origin == "JFK"), dep_time,
           time_between_dep = dep_time - lag(dep_time))) # not perfect


# 5.5.2 Exercises ---------------------------------------------------------

flights1 <- select(flights, year:day, contains("dep"), -dep_delay)
(mutate(flights1, dep_time_minutes = ((dep_time %/% 100) * 60) + 
          (dep_time %% 100), sched_dep_time_minutes = 
          ((sched_dep_time %/% 100) * 60) + (sched_dep_time %% 100)
        ))
(transmute(flights, air_time, arr.dep = arr_time - dep_time)) # wrong!
(transmute(flights, dep_time, arr_time, air_time, dep_time_minutes = 
             ((dep_time %/% 100) * 60) + (dep_time %% 100), 
             arr_time_minutes = ((arr_time %/% 100) * 60) + 
             (arr_time %% 100), calc_air_time = arr_time_minutes - 
             dep_time_minutes
           )) # WTF air_time is incorrect?????????
(select(flights, dep_time, sched_dep_time, dep_delay))
(transmute(flights, dep_delay, late_rank = min_rank(desc(dep_delay))))
(arrange(transmute(flights, dep_delay, late_rank = min_rank(desc(dep_delay))),
         late_rank))
(arrange(flights, desc(dep_delay)))


# 5.6 Grouped summaries with summarise() ----------------------------------

summarise(flights, delay = mean(dep_delay, na.rm = T))
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = T))

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest, 
  count = n(),
  dist = mean(distance, na.rm = T),
  delay = mean(arr_delay, na.rm = T)
  )
delay <- filter(delay, count > 20 & dest != "HNL")
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(mapping = aes(size = count), alpha = 0.3) +
  geom_smooth(se = F)

delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = T),
    delay = mean(arr_delay, na.rm = T)
  ) %>%
  filter(count > 20 & dest != "HNL")

not_cancelled <- flights %>% filter(!is.na(arr_delay) & !is.na(dep_delay))

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay)
  )
ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(bins = 100)

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    n = n(),
    delay = mean(arr_delay)
  )
ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 0.1)

delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
    geom_point(alpha = 0.1)

batting <- as_tibble(Lahman::Batting)
batters <- batting %>%
  group_by(playerID) %>%
  summarise(
    ba = sum(H, na.rm = T) / sum(AB, na.rm = T),
    ab = sum(AB, na.rm = T)
  )
batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point(alpha = 0.3) +
    geom_smooth(se = F)

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    avg_delay_all = mean(arr_delay),
    avg_delay_pos = mean(arr_delay[arr_delay > 0])
  )

not_cancelled %>%
  group_by(year, month, day) %>%
  transmute(dep_time, r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

not_cancelled %>%
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

not_cancelled %>%
  count(dest)

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(n_early = sum(dep_time < 500)) # note how sum() is used

not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(prop_hr_delay = mean(arr_delay > 60)) # note how mean() is used

daily <- group_by(flights, year, month, day)
per_day <- summarise(daily, flights = n())
per_month <- summarise(per_day, flights = sum(flights))
per_year <- summarise(per_month, flights = sum(flights))

daily %>% 
  ungroup() %>%
  summarise(flights = n())


# 5.6.7 Exercises ---------------------------------------------------------

not_cancelled %>%
  count(dest)

not_cancelled %>%
  group_by(dest) %>%
  summarise(n = n())

not_cancelled %>% 
  count(tailnum, wt = distance)

not_cancelled %>%
  group_by(tailnum) %>%
  summarise(distance_flown = sum(distance))

flights %>%
  group_by(year, month, day) %>%
  summarise(prop_delay = mean(dep_delay > 25, na.rm = T), 
            cancelled = sum(is.na(arr_time))) %>%
  ggplot(mapping = aes(x = prop_delay, y = cancelled)) +
  geom_point(alpha = 0.5) +
  geom_smooth(se = F)

not_cancelled %>%
  group_by(carrier) %>%
  summarise(mean_delay = mean(dep_delay)) %>%
  arrange(desc(mean_delay))

flights %>%
  group_by(carrier, dest) %>%
  summarise(n = n())

flights %>%
  count(dest, sort = T)


# 5.7 Grouped mutates (and filters) ---------------------------------------

flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(dep_delay)) <= 5)

popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)

popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)


# 5.7.1 Exercisees --------------------------------------------------------

flights %>%
  group_by(tailnum) %>%
  filter(n() > 100) %>%
  summarise(delayed = mean(arr_delay > 0, na.rm = T)) %>%
  arrange(desc(delayed))

flights %>%
  group_by(hour) %>%
  summarise(n = n(), ave_dep_delay = mean(dep_delay, na.rm = T)) %>%
  arrange(ave_dep_delay) # travel early!!

flights %>%
  group_by(dest) %>%
  summarise(sum(arr_delay, na.rm = T))

test1 <- flights %>%
  mutate(delay_lag = dep_delay - lag(dep_delay))
test1 <- test1[1:100, ]

ggplot(data = test1, mapping = aes(x = as.double(rownames(test1)), y = dep_delay)) +
  geom_line()
