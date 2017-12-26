
# 21 Iteration ------------------------------------------------------------

library(tidyverse)


# 21.2 For loops ----------------------------------------------------------

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

output <- vector(mode = "double", length = ncol(df))
for (i in 1:ncol(df)) {
  output[[i]] <- median(df[[i]])
}


# 21.2.1 Exercises --------------------------------------------------------

ncol(mtcars)
output <- vector(mode = "double", length = ncol(mtcars))
for (i in seq_along(mtcars)) {
  output[[i]] <- mean(mtcars[[i]])
}
print(output)

nycflights13::flights
output <- vector(mode = "character", length = ncol(nycflights13::flights))
for (i in seq_along(nycflights13::flights)) {
  output[[i]] <- typeof(nycflights13::flights[[i]])
}
print(output)

output <- vector(mode = "double", length = ncol(iris))
for (i in seq_along(iris)) {
  output[[i]] <- unique(iris[[i]]) %>% length()
}
print(output)

means <- c(-10, 0, 10, 100)
output <- matrix(nrow = length(means), ncol = 10)
for (i in seq_along(means)) {
  output[i, ] <- rnorm(10, mean = means[[i]])
}
print(output)

str_c(letters, collapse = "")

sd(sample(100))


# 21.3 For loop variations ------------------------------------------------

means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100, 1)
  output <- c(output, rnorm(n, means[[i]]))
}
str(output)

out <- vector("list", length(means))
for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)
str(unlist(out))


flip <- function() {
  sample(c("T", "H"), 1)
}

flips <- 0
nheads <- 0

while (nheads < 3) {
  if (flip() == "H") {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips


# 21.4 For loops vs. functionals ------------------------------------------

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[[i]] <- fun(df[[i]])
  }
  out
}

col_summary(df, fun = sd)
