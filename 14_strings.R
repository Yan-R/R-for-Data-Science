
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
x
str_replace_na(x)
str_c("|-", str_replace_na(x), "-|")

str_c("prefix-", c("a", "b", "c", "d"), "-suffix")
str_c(c("prefix-", "hellooo-", "mateee-"), c("a", "b", "c", "d", "e", "f"), "-suffix")

str_c("Good ", "Morning", "", " DUDE!")

name <- "Richard"
time_of_day <- "morning"
birthday <- TRUE
str_c("Good ", time_of_day, " ", name, if (birthday == T) " and HAPPY BIRTHDAY", ".")

# Objects of length zero are dropped: if statements, if FALSE, are length zero.

str_c("a", "b", "c")
str_c(c("a", "b", "c"))
str_c("a", "b", "c", collapse = "")
str_c(c("a", "b", "c", "d", "e", "f", "g"), collapse = "")
str_c(c("a", "b", "c"), c("x", "y", "z"))
str_c(c("a", "b", "c"), c("x", "y", "z"), collapse = ", ")

x <- c("Apple", "Pear", "Banana", "Watermelon", "Mandarin")
str_sub(x, 1, 4)
str_sub(x, -3, -1)
str_sub(x, -5, -1)

str_sub(x, -1, -1) <- str_to_upper(str_c(str_sub(x, -1, -1), "!"))
x

str_order(x, locale = "en")
str_sort(x)


# 14.2.5 Exercises --------------------------------------------------------

1:12 == c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
str_c(1:12, c("st", "nd", "rd", rep("th", 9)))
str_c(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), c("st", "nd", "rd", rep("th", 9)))
# collapse makes it such that the resulting vector becomes one string with the
# separator "" separating each value.
str_c(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), c("st", "nd", "rd", rep("th", 9)),
      collapse = ", ")
str_c(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), c("st", "nd", "rd", rep("th", 9)),
      sep = "hello")

x <- c("1", "12", "123", "1234", "12345")
str_sub(x, str_length(x) / 2 + 1, str_length(x) / 2 + 1)

str_wrap("To learn regular expressions, we’ll use str_view() and str_view_all(). These functions take a character vector and a regular expression, and show you how they match. We’ll start with very simple regular expressions and then gradually get more and more complicated. Once you’ve mastered pattern matching, you’ll learn how to apply those ideas with various stringr functions.", width = 40)
str_trim("    Hello, why are so many spaces at the beginning and end of this????   \t ")
str_pad("Richard", 10, "right", pad = "~")

x <- c("a", "b", "c", "d", "e")
str_c(x, if (length(x) == 0) "", 
    if (length(x) == 1) "", 
    if (length(x) == 2) c(", and ", ""), 
    if (length(x) > 2) c(rep(", ", length(x) - 2), ", and ", ""), collapse = "")


# 14.3 Matching patterns with regular expressions -------------------------

x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, "a")
str_view(x, ".a.")

dot <- "\\."
writeLines(dot)
str_view(c("abc", "a.c", "bef"), "a.c")
str_view(c("abc", "a.c", "bef"), "a\\.c")
# We need to use "\\" because regexps are written as strings. But it is another layer of
# interpretation in a way. So by having the string as '\\.', we are ensuring that the 
# string reading becomes '\.', which the regexp translates to '.' This means:

x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")
# Where \\\\ can be split up into: '\\' and '\\' to get '\\'.


# 14.3.1.1 Exercises ------------------------------------------------------

# Think of two layers of interpretation: string then regexp interp.
# If we are trying to match '\', then we need to have regexp see: '\\'
# To get regexp to see that we need to have a string: '\\\\'.

x <- "~~~\"\'\\~~~"
writeLines(x)
str_view(x, "\"\'\\\\")

x <- c("\\12\\34\\12", "\\23\\61\\23", "\\01\\25\\12")
str_view(x, "\\\\..\\\\..\\\\..")


# 14.3.2 Anchors ----------------------------------------------------------

x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

x <- c("apple", "apple pie", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")

x <- c("summarise", "sum", "summary", "rowsum")
str_view(x, "sum")
str_view(x, "\\bsum\\b")


# 14.3.2.1 Exercises ------------------------------------------------------

str_view("hello$^$myname", "\\$\\^\\$")

words

str_view(words, "^y", match = T)
str_view(words, "x$", match = T)
str_view(words, "^...$", match = T)
str_view(words, "^.......", match = T)


# 14.3.3 Character classes and alternatives -------------------------------

str_view(c("grey", "gray"), "gre|ay")
str_view(c("grey", "gray"), "gr(e|a)y")


# 14.3.3.1 Exercises ------------------------------------------------------

str_view(words, "^[aeiou]", match = T)
str_view(words, "^[^aeiou]*$", match = T)
str_view(words, "[^e]ed$", match = T)
str_view(words, "(ing$)|(ise$)", match = T)

str_view(words, "cei", match = T)
str_view(words, "cie", match = T)
str_view(words, "([^c]|)ei", match = T)

str_view(words, "q[^u]", match = T)

str_view(words, "[blv]our", match = T)

str_view(numbers, "^+614")


# 14.3.4 Repetition -------------------------------------------------------

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, "C[LX]+")
str_view("xxxppasaspppp", "pp+")

str_view(words, "colou?r", match = T)

str_view(x, "C{2,3}?")


# 14.3.4.1 Exercises ------------------------------------------------------

str_view("sdpoCCCCCCCpofsd", "CC?")
str_view("sdpoCCCCCCCpofsd", "C{2}")
str_view("sdpoCCCCCCCpofsd", "CC+")
str_view("sdpoCCCCCCCpofsd", "C{2,}")
str_view("sdpoCCCCCCCpofsd", "CC*")
str_view("sdpoCCCCCCCpofsd", "CC{0,}")

str_view(c("any thing.", "and(9)", "errythin'"), "^.*$")
str_view(c("{123}", "{14.9}", "{91218}"), "\\{.+\\}")
str_view(c("\\\\\\\\", "\\\\\\"), "\\\\{4}")

str_view(words, "^[^aeiou]{3}", match = T)
str_view(words, "[aeiou]{3,}", match = T)
str_view(words, "([aeiou][^aeiou]){2,}", match = T)


# The rest will not be too useful for me I feel...