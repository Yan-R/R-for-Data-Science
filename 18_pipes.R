
# 18 Pipes ----------------------------------------------------------------

library(magrittr)

cor(disp, mpg, data = mtcars)
# This function does not have a dataframe based API. So:
mtcars %>%
  cor(disp, mpg)
mtcars %$%
  cor(disp, mpg)
