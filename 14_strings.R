
# 14 Strings --------------------------------------------------------------

library(tidyverse)
library(stringr)

"'"
'"'
"\""
'\''
"\"
"\\"

x <- c("'", '"', "\"", '\'', "\\", "Hello, my name is:\nRichard!", "I want a tab here\t!")
writeLines(x) # RStudio seems to be confused

"\u00b5"

# We'll be using functions from the stringr packagee only, not the base functions

str_length(c("a", "R for data science", NA))

str_c("Life is ", "good!")
str_c("Three", "Two", "One!")
str_c("Three", "Two", "One!", sep = ", ")

x <- c("abc", "123", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

str_c("prefix-", c("a", "b", "c", "d"), "-suffix")

name <- "Richard"
time_of_day <- "morning"
birthday <- TRUE
str_c("Good ", time_of_day, " ", name, if (birthday == T) " and HAPPY BIRTHDAY", ".")

# Objects of length zero are dropped: if statements, if FALSE, are length zero.

str_c("a", "b", "c")
str_c(c("a", "b", "c"))
str_c(c("a", "b", "c", "d", "e", "f", "g"), collapse = "")
str_c(c("a", "b", "c"), c("x", "y", "z"), collapse = ", ")

x <- c("Apple", "Pear", "Banana", "Watermelon", "Mandarin")
str_sub(x, 1, 4)
str_sub(x, -3, -1)
str_sub(x, -5, -1)

str_sub(x, -1, -1) <- str_to_upper(str_sub(x, -1, -1))
x

str_order(x, locale = "en")
str_sort(x)


# 14.2.5 Exercises --------------------------------------------------------

str_c(1:12, c("st", "nd", "rd", rep("th", 9)))
str_c(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), c("st", "nd", "rd", rep("th", 9)))
# collapse makes it such that the resulting vector becomes one string with the
# separator "" separating each value.
str_c(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), c("st", "nd", "rd", rep("th", 9)),
      collapse = ", ")
