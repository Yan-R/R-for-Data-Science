
# 10 Tibbles --------------------------------------------------------------

library(tidyverse)

iris

as_tibble(iris)

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y, 
  a = "cool"
)

tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)

tribble(
  ~x, ~y, ~z,
  #--/---/---/
  "a", 2, 3.6,
  "b", 1, 8.5
)

# The two main differences between tibbles and data.frames are their behaviours when
# printing and subsetting.

# Tibbles don't stupidly print and overwhelm the entire console. They only print ten
# lines.

print(nycflights13::flights, n = 20, width = Inf)

options(tibble.print_min = 10, tibble.print_max = 20)

df <- tibble(
  x = runif(5), # random uniform
  y = rnorm(5),
  z = 1:5
)

df$x

df[["y"]]

df[[3]]

df %>% .$x

df %>% .[["y"]]

df %>% .[[3]]

# The main reason that some older functions don’t work with tibble is the [ function. 
# We don’t use [ much in this book because dplyr::filter() and dplyr::select() allow 
# you to solve the same problems with clearer code. Consider:

df[1, ]
filter(df, z ==1)

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

df <- tibble(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying$`1`
ggplot(annoying) +
  geom_point(aes(x = `1`, y = `2`))
new <- tibble(
  `1` = annoying$`1`,
  `2` = annoying$`2`,
  `3` = annoying$`2` / annoying$`1`
)
new2 <- tibble(
  one = annoying$`1`,
  two = annoying$`2`,
  three = new$`3`
)
