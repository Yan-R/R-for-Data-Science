
# 12 Tidy data ------------------------------------------------------------

library(tidyverse)

# There are three interrelated rules which make a dataset tidy:

# Each variable must have its own column.
# Each observation must have its own row.
# Each value must have its own cell.


# 12.3.1 Gathering --------------------------------------------------------

# Used when 'values' of variables are used as columns.
tidy4a <- table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>%
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)


# 12.3.2 Spreading --------------------------------------------------------

# Used when 'a single observation' is spread over different rows. This is
# accompanied by superfluous variables, with values that would usually
# form columns/variables themselves in tidy data.
table2 %>%
  spread(key = "type", value = "count")


# 12.3.3 Exercises --------------------------------------------------------

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>%
  spread(key = "year", value = "return") %>%
  gather(`2015`, `2016`, key = "year", value = "return")

table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases") %>%
  arrange(country, year)

people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
people %>%
  spread(key = "key", value = "value")

preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)
preg %>%
  gather(male, female, key = "gender", value = "count") # Is this right? I'm
# suspicious of the count column. Is it a valid variable?


# 12.4 Separating and uniting ---------------------------------------------

table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/", convert = T)

table3 %>%
  separate(year, into = c("century", "year"), sep = 2)

table5 %>%
  unite(new, century, year, sep = "")

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, into = c("one", "two", "three"), extra = "merge")

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "right")


# 12.5 Missing values -----------------------------------------------------

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

stocks %>%
  spread(key = "year", value = "return")

stocks %>%
  spread(key = "year", value = "return") %>%
  gather(`2015`, `2016`, key = "year", value = "return", na.rm = T)

stocks %>%
  complete(year, qtr)

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

treatment %>%
  fill(person, .direction = "down")

treatment %>%
  fill(person, .direction = "up")


# 12.6 Case study ---------------------------------------------------------

who

who1 <- who %>%
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = T)

who1 %>%
  count(key)

who2 <- who1 %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))

who2 %>%
  count(key)

who3 <- who2 %>%
  separate(key, c("new", "type", "sexage"), sep = "_")

who3 %>%
  count(new)

who4 <- who3 %>%
  select(-iso2, -iso3, -new)

who5 <- who4 %>%
  separate(sexage, c("sex", "age"), sep = 1)

tidywho <- who %>%
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = T) %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "type", "sexage"), sep = "_") %>%
  select(-iso2, -iso3, -new) %>%
  separate(sexage, c("sex", "age"), sep = 1)
  
tidywhoagg <- tidywho %>%
  group_by(country, year) %>%
  summarise(cases = sum(cases))

ggplot(data = tidywhoagg) +
  geom_jitter(mapping = aes(x = year, y = cases, colour = country), width = 0.5) +
  theme(legend.position = "none") +
  coord_cartesian(xlim = c(1995, 2012))
