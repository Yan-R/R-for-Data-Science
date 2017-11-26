
# 13 Relational data ------------------------------------------------------

library(tidyverse)
library(nycflights13)


# 13.2 nycflights13 -------------------------------------------------------

airlines
airports
flights
planes
weather


# 13.3 Keys ---------------------------------------------------------------

# A Primary Key uniquely identifies every single observation in the present table.
# A Foreign Key uniquely identifies every single observation in another table, but
# is present in the current table as a variable/column.

# An easy way to see if a variable or a set of variables is a Primary Key is to 
# count the number of instances in the table there are of each combination of those
# variables. There should only ever be 1 or 0 instances, never more.

# We know that in planes, tailnum is a primary key. To test this:
planes %>%
  count(tailnum) %>%
  filter(n > 1)

# We know that in flights, tailnum is a foreign key for planes. This is because it
# allows us to identify singular observations in planes. However, there are
# multiple observations for each tailnum in flights.


# We know that in weather, year, month, day, hour, origin is a primary key:
weather %>%
  count(year, month, year, day, hour, origin) %>%
  filter(n > 1)

# It is possible for a table to not have a readily available Primary Key.
# Each row may be an actual observation, but no combo of variables reliably
# identifies each observation. We might have to add a Primary Key in the form
# of a row number. This is a Surrogate Key.

# The relationship between a Primary Key and the corresponding Foreign Key in
# another table forms a relation. Relations are typically one-to-many. This
# is because both the Primary and Foreign Key are chosen to discern the
# observations of one of the tables. So in that table we have 'one', and in
# the other table, we have, often, 'many'. Consider flights and planes.
# The Primary Key in planes is tailnum. The Foreign Key in flights is tailnum.
# Each tailnum refers to one observation in planes, whereas it refers to many
# flights/observations in flights.


# 13.3.1 Exercises --------------------------------------------------------

flights %>%
  mutate(surrogate = row_number())

as.tibble(Lahman::Batting) %>%
  count(yearID, stint, playerID) %>%
  filter(n > 1)

babynames::babynames %>%
  count(year, sex, name) %>%
  filter(nn > 1)

nasaweather::atmos %>%
  count(lat, long, year, month) %>%
  filter(n > 1)

fueleconomy::vehicles %>%
  count(id) %>%
  filter(n > 1)

ggplot2::diamonds %>%
  mutate(surrogate = row_number()) %>%
  count(surrogate) %>%
  filter(n > 1)

library(Lahman)
as.tibble(Batting)
as.tibble(Master)
as.tibble(Salaries)
as.tibble(Master)
as.tibble(Managers)
as.tibble(AwardsManagers)


# 13.4 Mutating joins -----------------------------------------------------

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")

flights2 %>%
  select(-origin, -dest) %>%
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# Testing Inner and Outer Joins

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3",
  4, "x4",
  6, "x5",
  8, "x6"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3",
  5, "y4",
  6, "y5",
  7, "y6"
)

inner_join(x, y, by = "key")
left_join(x, y, by = "key")
right_join(x, y, by = "key")
full_join(x, y, by = "key") %>%
  arrange(key)
# left_join() is the most commonly used, with the 'y-table' being the 'additional'
# table. This all assumes that the 'key' is able to identify observations uniquely.
# This happens only very occassionally. A one-to-one relation.

# Sometimes a key variable or set of variables uniquely identifies one table, but
# not the other, in this case it is the Primary Key in one and a Foreign Key in 
# the other. This is a one-to-many relation.


# 13.4.5 Defining the key columns -----------------------------------------

flights2
weather

flights2 %>%
  left_join(weather, by = NULL)

flights2 %>%
  left_join(planes, by = "tailnum")
# This is when the variable name is the same in both cases. This isn't always
# the case. In those cases, we can write:

flights2 %>%
  left_join(airports, by = c("origin" = "faa")) %>%
  select(year, month, day, hour, origin, dest, name)

flights2 %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  select(year, month, day, hour, origin, dest, name)


# 13.4.6 Exercises --------------------------------------------------------

airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

flights %>%
  group_by(dest) %>%
  summarise(mean_delay = mean(arr_delay, na.rm = T)) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  ggplot(mapping = aes(x = lon, y = lat, colour = mean_delay)) +
  borders("state") +
  geom_point(size = 5) +
  coord_quickmap() +
  scale_colour_gradient(low = "black", high = "red")

flights %>%
  select(origin, dest) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  left_join(airports, by = c("origin" = "faa"))

flights %>%
  group_by(tailnum) %>%
  summarise(mean_delay = mean(arr_delay, na.rm = T)) %>%
  left_join(planes, by = "tailnum") %>%
  select(mean_delay, year) %>%
  ggplot() +
  geom_point(mapping = aes(x = year, y = mean_delay))

flights %>%
  left_join(weather, by = c("year", "month", "day", "hour", "origin")) %>%
  ggplot() +
  geom_point(mapping = aes(x = precip, y = dep_delay))

flights %>%
  filter(month == "6", day == "13") %>%
  group_by(dest) %>%
  summarise(mean_delay = mean(arr_delay, na.rm = T)) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  ggplot(mapping = aes(x = lon, y = lat, colour = mean_delay)) +
  borders("state") +
  geom_point(size = 5) +
  coord_quickmap() +
  scale_colour_gradient(low = "black", high = "red")


# 13.5 Filtering joins ----------------------------------------------------

top_dest <- flights %>%
  count(dest, sort = T) %>%
  head(10)

flights %>%
  filter(dest %in% top_dest$dest)

flights %>%
  semi_join(top_dest, by = "dest")

# anti_join() is useful for diagnosing mismatches. It allows us to see which
# observations don't have a match in the joining table we are looking at.
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = T)


# 13.5.1 Exercises --------------------------------------------------------

flights %>%
  anti_join(planes, by = "tailnum") %>%
  filter(carrier %in% c("AA", "MQ"))

common_planes <- flights %>%
  left_join(planes, by = "tailnum") %>%
  group_by(model) %>%
  count(sort = T) %>%
  filter(n >= 100)

flights %>%
  left_join(planes, by = "tailnum") %>%
  semi_join(common_planes, by = "model")

library(fueleconomy)
vehicles
common
vehicles %>%
  semi_join(common, by = c("make", "model"))

flights %>%
  group_by(year, month, day) %>%
  summarise(mean_delay = mean(dep_delay, na.rm = T)) %>%
  arrange(-mean_delay)

anti_join(flights, airports, by = c("dest" = "faa"))
anti_join(airports, flights, by = c("faa" = "dest"))