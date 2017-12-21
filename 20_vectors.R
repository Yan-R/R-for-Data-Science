
# 20 Vectors --------------------------------------------------------------

library(tidyverse)

letters
typeof(letters)
typeof(1:10)
typeof(seq(1, 10, 0.5))


# 20.3 Important types of atomic vector -----------------------------------

# Logical vectors
# Usually constructed with construction operators:
1:20 %% 3 == 0
# Or by hand:
c(TRUE, FALSE, TRUE, TRUE, NA)

# Numerical vectors
# Includes both integer and double vectors
typeof(2)
typeof(2L)
# Importantly, doubles are always approximations with the available amount
# of memory. So:
x <- sqrt(2) ^ 2
x
x - 2
x - 2 == 0
dplyr::near(x - 2, 0)
# Also:
typeof(c(-1, 0, 1))
c(-1, 0, 1) / 0

# Character vectors
x <- "This is a reasonably long string."
object.size(x)
y <- rep(x, 1000)
object.size(y)

typeof(c(TRUE, 1L))

typeof(c(1L, 1.5))

typeof(c(1.5, "a"))

library(purrr)

is_vector(c(1, 2))
sample(100)

last_val <- function(x) {
  x[[length(x)]]
}
last_val(c(1, 2, 3, 4, 5, 6, 2, 5, 1, 5, 1, 3))

even_pos_val <- function(x) {
  x[seq(1, length(x), by = 2)]
}
even_pos_val(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))

but_last_pos <- function(x) {
  x[-length(x)]
}
but_last_pos(c(1, 2, 3, 4, 5))

only_even_num <- function(x) {
  yes <- vector(length = length(x))
  for (i in 1:length(x)) {
    if (x[i] %% 2 == 0) {
      yes[i] <- TRUE
    } else {yes[i] <- FALSE}
  }
  x[yes]
}
only_even_num(c(1, 2, 3, 4, 2, 5, 7, 14, 6, 8, 2, 6, 8, 4, 8, 3, 78, 99, 99, 67, 37, 66, 35, 14, 12))

x <- c(-1, 2, 5, 3, 8, -1, -2, -7, -4, -10, 2, 0)
which(x > 0)


# 20.5 Recursive vectors (list) -------------------------------------------

x <- list(1, 2, 3)
str(x)
x <- list(x = 1, y = 2, z = 3)
str(x)
y <- list("a", 1L, 1.5, TRUE)
str(y)
z <- list(list(1, 2), list(3, 4))
str(z)

x <- tibble(a = c(1, 2), b = c(5, 3), c = c(8, 6))
x[1]
x[[1]]
x$a
x <- list(a = c(1, 2), b = c(5, 3), c = c(8, 6))
x[1]
x[[1]]
x$a

