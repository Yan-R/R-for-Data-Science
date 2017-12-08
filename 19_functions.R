
# 19 Functions ------------------------------------------------------------


# 19.2 When should you write a function? ----------------------------------

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$b, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
# Messy!
df

rescale01 <- function(x) {
  rng <- range(x, na.rm = T)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(c(0, 5, 10))
rescale01(c(-3, 7, 5))
rescale01(c(0, -2, 20, NA, 71))

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)


# 19.2.1 Practice ---------------------------------------------------------

rescale01 <- function(x, y) {
  rng <- range(x, na.rm = y)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(0, 5, 10, NA, 15), T)
rescale01(c(0, 5, 10, NA, 15), F)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = T)
  (x - rng[1]) / (rng[2] - rng[1])
  for(i in 1:length(x)) {
    if(x[i] == Inf) {
      x[i] <- 1
    }
    if(x[i] == -Inf) {
      x[i] <- 0
    }
  }
}

rescale01(c(0, 10, Inf, -Inf))

mean(is.na(c(0, 10, 2, 5, NA, 12, NA, 24, 1, 2, NA, NA)))

prop.na <- function(x) {
  sum(is.na(x)) / length(x)
}

prop.na(c(0, 10, 2, 5, NA, 12, NA, 24, 1, 2, NA, NA))

variance <- function(x) {
  sum((x - mean(x)) ^ 2) / (length(x) - 1)
}

x <- c(0, 10, 2, 5)
variance(c(0, 10, 2, 5))

both_na <- function(x, y) {
  count <- 0
  for(i in 1:length(x)) {
    if(is.na(x[i]) & is.na(y[i])) {
      count <- count + 1
    }
  }
  print(count)
}

both_na(c(1, 2, NA, 4, 5, 6, NA, NA), c(1, 2, NA, 3, 5, NA, 3, NA))

has_prefix <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}
has_prefix(c("in_cool", "out_leave", "three", "in_pull", "in_say"), "in")

x <- c("in_cool", "out_leave", "three", "in_pull", "in_say")
x[-length(x)]

but_last <- function(x) {
  if(length(x) <= 1) return(NULL)
  x[-length(x)]
}

but_last(c("cool", "man"))

