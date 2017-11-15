
# 3 Data visualisation ----------------------------------------------------

library(tidyverse)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = hwy > 25), shape = 16, size = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv, colour = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(linetype = drv, colour = drv)) +
  geom_point(mapping = aes(colour = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = class)) +
  geom_smooth(data = filter(mpg, class == "suv"), se = FALSE)


ggplot(data = mpg, mapping = aes(x = hwy)) +
  geom_histogram(binwidth = 1, fill = "blue")

ggplot(data = mpg, mapping = aes(x = hwy, y = ..density..)) +
  geom_histogram(binwidth = 1, mapping = aes(fill = drv))

ggplot(data = mpg, mapping = aes(x = hwy, y = ..density..)) +
  geom_freqpoly(binwidth = 3, mapping = aes(colour = drv))

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot(mapping = aes(colour = class), outlier.shape = 3) +
  coord_flip()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_line() +
  geom_point()
  

# Exercise 3.6.1 ----------------------------------------------------------

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 3) +
  geom_smooth(colour = "blue", se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 3) +
  geom_smooth(mapping = aes(group = drv), colour = "blue", se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = drv), size = 3) +
  geom_smooth(mapping = aes(colour = drv), se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = drv), size = 3) +
  geom_smooth(colour = "blue", se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = drv), size = 3) +
  geom_smooth(mapping = aes(linetype = drv), colour = "blue", se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(fill = drv), size = 3, shape = 21, colour = "white", stroke = 3)


# 3.7 Statistical transformations -----------------------------------------

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)
ggplot(data = demo) +
  geom_bar(stat = "identity", mapping = aes(x = cut, y = freq))

ggplot(data = demo) +
  geom_col(mapping = aes(x = cut, y = freq))

ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = depth), 
               fun.ymax = max, 
               fun.ymin = min, 
               fun.y = median
               )

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))


# 3.8 Position adjustments ------------------------------------------------

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "identity")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, colour = clarity), position = "identity", fill = NA)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")


# 3.8.1 Exercises ---------------------------------------------------------

ggplot(data = mpg) +
  geom_count(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = hwy, fill = drv), position = "dodge")

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = hwy, fill = drv), position = "identity")


# 3.9 Coordinate systems --------------------------------------------------

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = hwy)) +
  coord_flip()

library(maps)
nz <- map_data("nz")
ggplot(data = nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

bar <- ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), 
           show.legend = F, 
           width = 1
           ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)
bar + coord_flip()
bar + coord_polar()


# 3.9.1 Exercises ---------------------------------------------------------

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill") +
  coord_polar()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()