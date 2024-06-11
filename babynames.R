# DataLab 06.11.2024; Git (Week 3, Day 2, Session 3)

library(tidyverse)
library(babynames)

# 9) Make an object called bb_names by running babynames <- bb_names.

bb_names <- babynames


# 10) Create a histogram of the name Marie since 1982.
ggplot(data = bb_names %>% filter(year >= 1982, name == "Marie")) +
  geom_col(aes(x = year, y = n))

# 11) Create a line plot for proportion of the name Joe, colored by sex. Make the lines a bit thicker and more transparent.

ggplot(data = bb_names %>% filter(name == "Joe")) +
  geom_line(aes(x = year, y = prop, color = sex, alpha = 0.5, linewidth = 2)) # prop for proportion in this dataset!

# 12) Add new x and y axis labels, as well as a chart title.
ggplot(data = bb_names %>% filter(name == "Joe")) +
  geom_line(aes(x = year, y = prop, color = sex, alpha = 0.5, linewidth = 2)) +
  labs(title = "Baby Name Joe used for Males vs. Females",
       x = "Year",
       y = "Proportion")

# 13) Create a bar chart of all female names in 2002.

ggplot(data = bb_names %>% filter(name %in% c("Emily", "Madison", "Hannah", "Emma", "Olivia"), sex == "F", year == 2002)) +
  geom_col(aes(x = name, y = prop)) +
  labs(title = "Common Girl Names in 2002",
       x = "Name",
       y = "Proportion")

# 14) Make the bars transparent and filled with the color blue.

ggplot(data = bb_names %>% filter(name %in% c("Emily", "Madison", "Hannah", "Emma", "Olivia"), sex == "F", year == 2002)) +
  geom_col(aes(x = name, y = prop), fill = 'lightblue', alpha = 0.75) +
  labs(title = "Common Girl Names in 2002",
       x = "Name",
       y = "Proportion")

# 15) Create a new data set called the_nineties that only contains years from the 1990s.
the_nineties <- bb_names %>% filter(year >= 1990, year <= 1999)

# 16) Save this dataset to your repository (use write_csv()).
write_csv(the_nineties, file = "babynames_90s.csv")

# 17) Add, commit, and push your files to GitHub. Check GitHub and make sure that your code successfully pushed.



# 18) In RStudio pull from GitHub. Is it already up to date?

#   19) Now that everything is up to date, make a visualisation of you and your team member’s names for a year of your choice.

# 20) Make a visual that looks at your name over time. What happens if you color by sex?

#   21) Don’t forget to stage/add, commit, and push your hardwork to GitHub!
