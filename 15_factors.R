
# 15 Factors --------------------------------------------------------------

library(tidyverse)
library(forcats)


# 15.2 Creating factors ---------------------------------------------------

x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")
sort(x1)

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
y1 <- factor(x1, levels = month_levels)
sort(y1)
y2 <- factor(x2, levels = month_levels)
y2 <- parse_factor(x2, levels = month_levels)
y2
sort(y2)

factor(x2)

# To have factors listed in order of apprearance rather than alphabetically:
f1 <- factor(x1, levels = unique(x1))
f2 <- x1 %>% factor() %>% fct_inorder()

levels(f2)


# 15.3 General Social Survey ----------------------------------------------

gss_cat

levels(gss_cat$race)
gss_cat %>%
  count(race)
ggplot(data = gss_cat, mapping = aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = F)


# 15.3.1 Exercise ---------------------------------------------------------

ggplot(data = gss_cat) +
  geom_bar(mapping = aes(x = rincome))
gss_cat %>%
  count(relig) %>%
  arrange(-n)
gss_cat %>%
  count(partyid) %>%
  arrange(-n)
print(gss_cat %>%
  select(relig, denom) %>%
  count(relig, denom), 
  n = Inf
  )
gss_cat %>%
  count(relig, denom) %>%
  mutate(rw = row_number()) %>%
  ggplot() +
  geom_col(mapping = aes(x = rw, y = n))


# 15.4 Modifying factor order ---------------------------------------------

relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = T),
    tvhours = mean(tvhours, na.rm = T),
    n = n())
ggplot(data = relig_summary) +
  geom_point(mapping = aes(x = tvhours, y = relig))

ggplot(data = relig_summary) +
  geom_point(mapping = aes(x = tvhours, y = fct_reorder(f = relig, x = tvhours)))
relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot() +
  geom_point(aes(x = tvhours, y = relig)) # this is interesting because the
# mutate step itself doesn't actually do anything to the tibble!!! It is only
# when combined with ggplot that it actually reorders the factors!!!

rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = T),
    tvhours = mean(tvhours, na.rm = T),
    n = n()
  )
ggplot(data = rincome_summary, mapping = aes(x = age, y = rincome)) +
  geom_point()

ggplot(data = rincome_summary) +
  geom_point(mapping = aes(x = age, y = fct_relevel(f = rincome, "Not applicable")))

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  group_by(age, marital) %>%
  count() %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(data = by_age) +
  geom_line(mapping = aes(x = age, y = prop, colour = marital), na.rm = T)

ggplot(data = by_age) +
  geom_line(mapping = aes(x = age, y = prop, colour = fct_reorder2(marital, age, prop))) +
  labs(colour = "marital")
# This is a very specific application, so that the lines line up with their respective
# colours in the legend to the right.

gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot() +
  geom_bar(mapping = aes(x = marital))


# 15.4.1 Exercises --------------------------------------------------------

gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = T),
    tvhours = mean(tvhours, na.rm = T),
    n = n()
    ) %>%
  ggplot() +
  geom_point(mapping = aes(x = tvhours, y = fct_reorder(f = relig, x = tvhours)))

gss_cat

levels(gss_cat$rincome)
levels(gss_cat$partyid)


# 15.5 Modifying factor levels --------------------------------------------

gss_cat %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat",
    "Other"                 = "No answer",
    "Other"                 = "Don't know",
    "Other"                 = "Other party"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
    other = c("No answer", "Don't know", "Other party"),
    rep = c("Strong republican", "Not str republican"),
    ind = c("Ind,near rep", "Independent", "Ind,near dem"),
    dem = c("Not str democrat", "Strong democrat")
    )) %>%
  count(partyid)

gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = T)


# 15.5.1 Exercises --------------------------------------------------------

levels(gss_cat$partyid)
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
    other = c("No answer", "Don't know", "Other party"),
    ind = c("Ind,near dem", "Ind,near rep", "Independent"),
    rep = c("Strong republican", "Not str republican"),
    dem = c("Strong democrat", "Not str democrat")
  )) %>%
  group_by(partyid) %>%
  summarise(
    n = n()
  ) %>%
  mutate(
    prop = 
  )
