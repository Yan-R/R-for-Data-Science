
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


