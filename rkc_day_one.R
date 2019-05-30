# you can install packages like so
packages <- c('tidyr', 'dplyr', 'ggplot2')
install.packages(packages)

# or one at a time
install.packages('tidyr')

# load packages at the top of your script
library(tidyr)
library(ggplot2)
library(dplyr)

# you can use R like a calculator
3+3
3+4 # this is some math

2/100000

print('3+3')

# built in mathematical functions
sin(1)
log(1)

# comparisons
1 == 1 # test for equality
1 != 1 # test for inequality
1 < 2 # less than, etc.

# for floating number ('double'), don't use the double equal, use all.equal()
1/40 == 1/40 # don't do this
all.equal(1/40, 1/40) # do this

x <- 1/40 # assigning value to a variable
x = 1/40 # this works too, but <- is preferred in R

log(x) # do operations on a variable

x <- 100 # assigning a new value, old value is gone

# Variable names can contain letters, numbers, underscores and periods. They
# cannot start with a number nor contain spaces at all. Different people use
# different conventions for long variable names, these include

periods.between.words
underscores_between_words
camelCaseToSeparateWords

# challenge: which of these are allowed variable names?

min_height # allowed
max.height # allowed
_age # not allowed, leading underscore
.mass # not allowed, leading period
MaxLength # allowed
min-length # not allowed, cannot use dashes in variable names
2widths # not allowed, starts with a number
celsius2kelvin # allowed

# creatinga data frame cats with three variables
cats <- data.frame(coat = c('calico','black', 'tabby'),
                    weight = c(2.1, 5.0, 3.2),
                   likes_string = c(1, 0, 1))
# write our data frame out as a csv, store in our working directory
write.csv(x = cats, file = "feline-data.csv", row.names = FALSE)

# c() creates vectors, must all be the same type of data, or R will coerce the
# data into the simplest type
x <- c("cats", 2.3, FALSE)
y <- c(x, 5.6) # can also use c() to add onto a previous vector

# can change the levels of a factor variable
cats$coat <- factor(cats$coat, levels = c("tabby", "calico", "black"))

# creating a vector that is a sequenece of numbers. 
z <- 1:10
z <- seq(1, 10, by = 1) # these are both equivalent

# challenge: create a vector of 1 to 26, double it, and then give each value a
# name with the letters A-Z
x <- 1:26
x <- x*2
names(x) <- c("a", "b", "c")
names(x) <- LETTERS

# lists can contain different types of data
y <- list("Calico", 4, 8, TRUE)

# matrices can be filled by column (default) or by row
matrix_example <- matrix(1:25, ncol = 5, nrow = 5)
matrix_example <- matrix(1:25, ncol = 5, nrow = 5, byrow = TRUE)

# can add a column to a data frame using cbind
age <- c(2, 3, 5)
cats <- cbind(cats, age)

# can add a row to the data frame using rbind (remember rows are lists)
fluffy <- list("tortoise shell", 3.3, TRUE, 9)
cats <- rbind(cats, fluffy)

# but! you must add the new 'level' to our factor variable
levels(cats$coat) <- c(levels(cats$coat), "tortoise shell")

#removing rows
cats[-4,]
na.omit(cats)

#removing columns
cats[,-4]

# download gapminder data and load it for our next examples
download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder_data.csv", destfile = "gapminder.csv")
gapminder <- read.csv("gapminder.csv")

# ways to look at your data
head(gapminder, 12) # first 6 rows by default, number can change that
head(gapminder, -12) # negative means to skip the first X rows
tail(gapminder, 10) # last 6 rows by default, number can change that
str(gapminder) # look at the structure of your data frame
dim(gapminder) # dimensions (rows, columns)
View(gapminder) # load the data frame in the spreadsheet-style viewer

# can also load the CSV and NOT read the string as factors
gapminder <- read.csv("gapminder.csv", stringsAsFactors = FALSE)

# ways to filter data
gapminder[3,] # 3rd row, all columns
gapminder[,3] # all rows, 3rd column
gapminder[gapminder$country == 'Mexico',] # rows where country is Mexico
gapminder[gapminder$year < 1992, 1] # rows where year is after 1992, 1st column

# challenge
gapminder[gapminder$year = 1957,] # incorrect
gapminder[gapminder$year == 1957,] # correct

gapminder[,-1:4] # incorrect
gapminder[,-(1:4)] # correct

gapminder[gapminder$lifeExp > 80] # incorrect
gapminder[gapminder$lifeExp > 80,] # correct

gapminder[gapminder$year == 2002 | 2007, ] # incorrect
gapminder[gapminder$year == 2002 | gapminder$year == 2007, ] # correct

gapminder_sm <- gapminder[1:20, 1:3] # after subsetting, can assign to a new df

# create list of se Asian countries
seAsia <- c("Myanmar","Thailand","Cambodia","Vietnam","Laos")

# read in the gapminder data that we downloaded in episode 2
gapminder <- read.csv("data/gapminder_data.csv", header=TRUE)

# extract the `country` column from a data frame (we'll see this later);
# convert from a factor to a character and get just the non-repeated elements
countries <- unique(as.character(gapminder$country))

# wrong way, doesn't work
gapminder[gapminder$country == seAsia,]

# technically correct, but clunky
gapminder[gapminder$country == seAsia[1] | gapminder$country == seAsia[2] |
            gapminder$country == seAsia[3] | gapminder$country == seAsia[4] |
            gapminder$country == seAsia[5], ]

# correct way to pull out all countries in se Asia, use %in% operator
gapminder[gapminder$country %in% seAsia,]

# Control Flow

# basic idea (code won't work)

if (condition is applies) {
  do something
} else if (other condition applies) {
  do another thing
} else {
  do this
}

# real example  
x <- 8

if (x >= 10) {
  print("x is greater than or equal to 10")
} else if (x > 5) {
  print("x is greater than 5, but less than 10")
} else {
  print("x is less than 10")
}

# can use this on datasets, too - but be sure to use all() or any() to evaluate
# all of the observations
if (any(gapminder$year == 2002)) {
  print("there are records from 2002")
}

if (all(gapminder$year == 2002)) {
  print("there are records from 2002")
}
