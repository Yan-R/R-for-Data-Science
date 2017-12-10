
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

library(lubridate)
now()

greeting <- function() {
  if (hour(now()) >= 0 && hour(now()) < 12) {
    print("Good morning!")
  } else if (hour(now()) >= 12 && hour(now()) < 18) {
    print("Good afternoon!")
  } else {
    print("Good evening!")
  }
}
greeting()

fizzbuzz <- function(x) {
  if (x %% 3 == 0 && x %% 5 == 0) {
    print("fizzbuzz")
  } else if (x %% 3 == 0) {
    print("fizz")
  } else if (x %% 5 == 0) {
    print("buzz")
  } else {
    print(x)
  }
}
fizzbuzz(33)

if (temp <= 0) {
  "freezing"
} else if (temp <= 10) {
  "cold"
} else if (temp <= 20) {
  "cool"
} else if (temp <= 30) {
  "warm"
} else {
  "hot"
}

temp <- seq(-10, 50, by = 5)

cut(temp, breaks = c(-Inf, 0, 10, 20, 30, Inf), labels = c("freezing", "cold", "cool", "warm", "hot"), right = T)
cut(temp, breaks = c(-Inf, 0, 10, 20, 30, Inf), labels = c("freezing", "cold", "cool", "warm", "hot"), right = F)

switch(1, "one", "two", "three", "four")

switch("a", 
       a = ,
       b = "ab",
       c = ,
       d = "cd"
)

range_mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  ok <- mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
  ok[2] - ok[1]
}

range_mean_ci(runif(100), conf = 0.99)

wt_mean <- function(x, w) {
  sum(x * w) / sum(w)
}
wt_var <- function(x, w) {
  mu <- wt_mean(x, w)
  sum(w * (x - mu) ^ 2) / sum(w)
}
wt_sd <- function(x, w) {
  sqrt(wt_var(x, w))
}

wt_mean(1:6, 1:3)

wt_mean <- function(x, w) {
  if(length(x) != length(w)) {
    stop("`x` and `w` must be the same length", call. = F)
  }
  sum(x * w) / sum(w)
}
wt_mean(1:6, 1:3)

wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  if (na.rm) {
    miss <- is.na(x) | is.na(w)
    x <- x[!miss]
    w <- w[!miss]
  }
  
  sum(x * w) / sum(w)
}
wt_mean(1:6, 1:6, na.rm = c(F, T))


commas <- function(...) {stringr::str_c(..., collapse = ", ")}
commas(letters[1:10])
commas(c("pizza", "fruit", "cake", "milk", "cheese", "biscotto", "arancini", "bruschetta"))

title <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}

title("Life is very good")

commas(letters, collapse = "-")

`+` <- function(x, y) {
  if (runif(1) < 0.1) {
    sum(x, y)
  } else {
    sum(x, y) * 1.1
  }
}
table(replicate(1000, 1 + 2))

rm(`+`)
