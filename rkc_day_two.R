library(ggplot2)
library(tidyr)
library(dplyr)

## NOTE: do NOT load plyr, only dplyr -- count(), n(), and group_by() from dplyr
## do not work if you have plyr loaded

# make sure you are in your working directory
setwd("~/your/workingdirectory")

# read in the gapminder data
gapminder <- read.csv("gapminder.csv")

## ggplot2

# base R plotting is bare bones (though you can add styling, it is a pain)
plot(gapminder$gdpPercap, gapminder$lifeExp)

# basic ggplot plot of gdp per capita by life expectancy
ggplot(data = gapminder, 
       aes(x = gdpPercap, 
           y = lifeExp)) + 
  geom_point()

# plot of life expectancy over time
ggplot(data = gapminder, 
       aes(x = year, 
           y = lifeExp)) + 
  geom_point()

# you can add a color aesthetic
ggplot(data = gapminder, 
       aes(x = year, 
           y = lifeExp, 
           color = continent)) + 
  geom_point()

# you can add both lines and points - make sure you include the by= aesthetic
ggplot(data = gapminder, 
       aes(x = year, 
           y = lifeExp, 
           color = continent, 
           by = country)) + 
  geom_line() + 
  geom_point()

# you can separately apply aesthetics to each geom, instead of in the global
# ggplot call
ggplot(data = gapminder, 
       aes(x = year, 
           y = lifeExp, 
           by = country)) + 
  geom_point(aes(size = gdpPercap)) + 
  geom_line(aes(color = continent))

# you can use aesthetic features (color, size, shape, alpha, etc) out side of
# the aes() function in order to just set them, rather than apply them to data
ggplot(data = gapminder, 
       aes(x = year, 
           y = lifeExp, 
           by = country)) + 
  geom_point(alpha = 0.5)

# can also do scale transformations, here is transforming the x scale by log10
ggplot(data = gapminder, 
       aes(x = gdpPercap, 
           y = lifeExp)) + 
  geom_point(alpha = 0.5) + 
  scale_x_log10()

# can add a fit line, here is one using linear method, also faceted by continent
ggplot(data = gapminder, 
       aes(x = gdpPercap, 
           y = lifeExp)) + 
  geom_point(alpha = 0.5) + 
  scale_x_log10() + 
  geom_smooth(method='lm', 
              size = 1.5) + 
  facet_wrap(~ continent)

# you can store your plot in an object
lifeExpPlot <- ggplot(data = gapminder, 
                      aes(x = gdpPercap, 
                          y = lifeExp, 
                          color = continent)) + 
  geom_point(alpha = 0.5) + 
  scale_x_log10() + 
  geom_smooth(method='lm', size = 1.5) + 
  labs(x = "GDP per capita",
       y = "Life expectancy",
       title = "Figure 1",
       color = "Continent") +
  theme(axis.text.x = element_text(angle = 90, 
                                   hjust = 1))

lifeExpPlot

# saving your plot with ggsave
ggsave(filename = 'LifeExp.png', 
       plot = lifeExpPlot, 
       width = 12, 
       height = 10, 
       dpi = 300, 
       units = "cm" )

# challenge: create a density plot of gdpPercap, transform x axis using log10
ggplot(gapminder, 
       aes(x = gdpPercap, 
           fill = continent)) + 
  geom_density(alpha = 0.5) + 
  scale_x_log10()

# dplyr

# if you wanted to calculate mean gdpPercap for each continent, you could do it
# this way, but it would take a while and be repetitive:
mean(gapminder[gapminder$continent == "Africa", "gdpPercap"])
mean(gapminder[gapminder$continent == "Americas", "gdpPercap"])

# instead, you can use dplyr!


# select() and filter()
year_country_gdp <- select(gapminder, year, country, gdpPercap)
head(year_country_gdp)

# %>% piping helps you when you have a string of commands you are using
gapminder %>% 
  select(year, country, gdpPercap) %>% 
  filter(year == 1972)

# this is equivalent to the above piped version, but isn't as easy to read
filter(select(gapminder, year, country, gdpPercap), year == 1972)

# order of operations matters when using filter/select
gapminder %>% select(lifeExp, country, year) %>% filter(continent == 'Africa') 

# the above doesn't work because you don't have the continent column to filter
# on after you select the others
gapminder %>% filter(continent == 'Africa') %>% select(lifeExp, country, year)

# group_by()
gapminder %>%
  select(continent, gdpPercap) %>%
  group_by(continent) %>%
  summarise(mean_gdpPercap = mean(gdpPercap)) %>%
  arrange(desc(mean_gdpPercap))

gapminder %>%
  select(continent, gdpPercap, year) %>%
  group_by(continent, year) %>%
  summarise(mean_gdpPercap = mean(gdpPercap))

gapminder %>%
  select(continent, gdpPercap) %>%
  group_by(continent) %>%
  summarise(mean_gdpPercap = mean(gdpPercap))

# count() to count number of observations
gapminder %>%
  filter(year == 2002) %>%
  count(continent)

# mutate() makes new variables
gapminder_billion <- gapminder %>%
  mutate(gdp_billion = gdpPercap*pop/10^9)
head(gapminder_billion)


# tidyr and reshaping data

# gapminder data is somewhere in between wide and long
View(gapminder)

# download and load wide gapminder data
url <- "https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_wide.csv"
download.file(url, destfile = "gapminder_wide.csv")
gapminder_wide <- read.csv("gapminder_wide.csv")

# using gather() to make wide data long
gap_long <- gapminder_wide %>%
  gather(obstype_year, 
         obs_values, 
         starts_with('pop'), 
         starts_with('lifeExp'), 
         starts_with('gdpPercap')) %>%
  separate(obstype_year, 
           into=c('obs_type', 
                  'year', 
                  sep = '_'))
View(gap_long)

# spread() the long data out just a bit, to get our original gapminder data
gap_normal <- gap_long %>% spread(obs_type, obs_values)
View(gap_normal)
