
# 11 Data import ----------------------------------------------------------

library(tidyverse)

read_csv("a,b,c
         1,2,3
         4,5,6
         7,8,9")

read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3
         4,5,6", skip = 2)

read_csv("# A comment I want to skip!!!
         x,y,z
         1,2,3
         4,5,6", comment = "#")

read_csv("1,2,3,4\n4,5,6,7", col_names = FALSE)

read_csv("1,2,3\n4,5,6", col_names = c("coolio", "man", "dude"))

read_csv("
         1,7,3,.
         .,4,5,6
         2,7,.,3", na = ".", col_names = F)

read_delim("I would like to skip this line
           1|2|3
           4|5|6", delim = "|", col_names = F, skip = 1)

read_delim("Life is good',' Hudson., Fantastic!
         No',' thank you!, Coolio", col_names = F, delim = ",") #HELP?

read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")


# 11.3 Parsing a vector ---------------------------------------------------

str(c("TRUE", "FALSE", "NA"))
str(c(1.5, 2, 3))
str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

parse_integer(c("1", "2", ".", "4"), na = ".")
x <- parse_integer(c("1", "2", ".", "4.3"))
problems(x) # itself a tibble!


# 11.3.1 Numbers ----------------------------------------------------------

# parse_double() & parse_number()

parse_double(c("1.2", "4.23"))
parse_double(c("1,2", "4,23"), locale = locale(decimal_mark = ","))

parse_number(c("$100", "$205"))
parse_number(c("20%", "35%"))
parse_number(c("Total cost $200.45", "Total revenue: $300.60"))

parse_number("$21,002,361.68")
parse_number("$21.002.361,68", locale = locale(grouping_mark = "."))
parse_number("$21'002'361.68", locale = locale(grouping_mark = "'"))


# 11.3.2 Strings ----------------------------------------------------------

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# Sometimes we can expect to find the correct encoding for string parsing in the data
# documentation. Other times we might need to use guess_encoding():
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))


# 11.3.3 Factors ----------------------------------------------------------

fruits <- c("banana", "apple", "mango")
parse_factor(c("banana", "apple", "apple", "mango", "pineapple"), levels = fruits)
parse_factor(c("banana", "apple", "apple", "mango"), levels = fruits)

# But if you have many problematic entries, it’s often easier to leave as character 
# vectors and then use the tools you’ll learn about in strings and factors to clean 
# them up.


# 11.3.4 Dates, date-times, and times -------------------------------------

parse_datetime(c("2017-11-21T224707", "2017-11-21T224737"))

parse_date(c("2014-11-18", "2017/11/21"))

parse_time("01:18 pm")

parse_time("22:50:08")

# If the data that we are importing / attempting to parse has an unconventional
# format for date and/or time:

parse_date("21/11/2017", format = "%d/%m/%Y")

parse_date("21/11/17", format = "%d/%m/%y")

parse_date("21st Nov, 2017", format = "%d%.%.%.%b%.%.%Y")

parse_date("13th Apr, 2018", format = "%d%.%.%.%b%.%.%Y")

parse_time("1456", format = "%H%M")


# 11.3.5 Exercises --------------------------------------------------------

locale = locale(decimal_mark = ".", grouping_mark = ",", encoding = "UTF-8")

parse_number(c("200,123.67", "214,623.62"), locale = locale(decimal_mark = ".",
                                                            grouping_mark = "."))

AUS_LOCALE <- locale(decimal_mark = ".", grouping_mark = ",", encoding = "UTF-8")

d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, format = "%B%.%d%.%.%Y")
parse_date(d1, format = "%B %d, %Y")
parse_date(d2, format = "%Y-%b-%d")
parse_date(d2, format = "%Y%.%b%.%d")
parse_date(d3, format = "%d-%b-%Y")
parse_date(d4, format = "%B %d %.%Y%.")
parse_date(d5, format = "%m/%d/%y")
parse_time(t1, format = "%H%M")
parse_time(t2, format = "%I:%M:%OS %p")


# 11.4 Parsing a file -----------------------------------------------------

guess_parser(c("1", "2", "5", "3"))
guess_parser(c("2017/11/22", "2017-11-25"))
guess_parser(c("T", "F", "T", "T"))
guess_parser(c("12,412,736", "239,231"))

str(parse_guess("2010-10-10"))

challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)
# Lots of problems with column x. There are trailing characters where it expects none
# because readr has parsed assuming integers. Fixing this:
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)
tail(challenge)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
tail(challenge)

# Always try to supply col_types = cols() with the read_csv() function!!! This keeps
# it consistent and easy to spot mistakes.

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
problems(challenge2) # i.e. NONE!

challenge3 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character()))
challenge3
type_convert(challenge3)
