
# 11 Data import ----------------------------------------------------------

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

