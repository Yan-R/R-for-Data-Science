
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


