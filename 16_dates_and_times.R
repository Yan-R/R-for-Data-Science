
# 16 Dates and times ------------------------------------------------------

library(tidyverse)
library(lubridate)
library(nycflights13)


# 16.2 Creating date/times ------------------------------------------------

today()
now()


# 16.2.1 From strings -----------------------------------------------------

parse_date("07/12/17", "%d/%m/%y")
ymd("2017/12/07")
mdy("December 7, 2017")
dmy("7th Dec 2017")

ymd_hm("2017-12-07 21:01")


# 16.2.2 From individual components ---------------------------------------

flights
flights %>%
  select(year, month, day, hour, minute)
make_date(flights$year, flights$month, flights$day)
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))

flights
make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt

flights_dt %>%
  ggplot() +
  geom_freqpoly(mapping = aes(x = dep_time), binwidth = 86400)

flights_dt %>%
  filter(dep_time < ymd(20130102)) %>%
  ggplot() +
  geom_freqpoly(mapping = aes(x = dep_time), binwidth = 600)


# 16.2.3 From other types -------------------------------------------------

today()
now()

as_datetime(today())
as_date(now())


ymd("2010-10-01", "bananas")

d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014

mdy(d1)
ymd(d2)
dmy(d3)
mdy(d4)
mdy(d5)