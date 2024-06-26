## Adri E. Silva
## 06.13.2024
## DataLab Week 3, Day 4, Session 3: Sentiment

# 1. Start a new script. Name it “sentiment.R”.
# 2. Set up your work space by loading the ggplot2, dplyr, tidytext, gsheet, wordcloud2, sentimentr, and lubridate packages.
library(tidyverse)
library(dplyr)
library(tidytext)
library(gsheet)
library(wordcloud2)
library(sentimentr)
library(lubridate)

# 3. Read in your survey data by running the following:
survey <- gsheet::gsheet2tbl('https://docs.google.com/spreadsheets/d/1W9eGIihIHppys3LZe5FNbUuaIi_tfdscIq521lidRBU/edit?usp=sharing')

# 4. Take a look at the first few rows of the data. What is the unit of observation?
head(survey) # ?

#   5. Create a variable named date_time in your survey data. This should be based on the Timestamp variable. Use the mdy_hms variable to created a “date-time” object.
survey <- survey %>% mutate(date_time = mdy_hms(survey$Timestamp))

# 6. Create a visualization of the date_time variable.
ggplot(data = survey, aes(x = date_time)) + geom_histogram()

# 7. Create an object called sentiments by running the following:
sentiments <- get_sentiments('bing')

#   8. Explore the sentiments object. How many rows? How many columns? What is the unit of observation.
nrow(sentiments) # 6786 rows
ncol(sentiments) # 2 columns
# unit of observation: words

# 9. Create an object named words by running the following:
words <- survey %>%
  dplyr::select(first_name,
                feeling_num,
                feeling) %>%
  unnest_tokens(word, feeling)

# 10. Explore words. What is the unit of observation.
      # unit of observation: 

# 11. Look up the help documentation for the function wordcloud2. What does it expect as the first argument of the function?
      # A data frame including word and freq in each column.

#   12. Create a dataframe named word_freq. This should be a dataframe which is conformant with the expectation of wordcloud2, showing how frequently each word appeared in our feelings.
word_freq <- words %>% group_by(word) %>% tally()

# 13. Make a word cloud.
wordcloud2(data = word_freq)

# 14. Run the below to create an object named sw.
sw <- read_csv('https://raw.githubusercontent.com/databrew/intro-to-data-science/main/data/stopwords.csv')

# 15. What is the sw object all about? Explore it a bit.
      # words that do not have sentiment / do not fit the purposes of this project 

# 16. Remove from word_freq any rows in which the word appears in sw.
word_freq_clean <- anti_join(word_freq, sw, by = "word")
  # OR: word_freq_clean <- word_freq %>% filter(!word %in% sw$word)

# 17. Make a new word cloud.
wordcloud2(data = word_freq_clean)

# 18. Make an object with the top 10 words used only. Name this object top10.
top10 <- head(word_freq_clean[order(-word_freq_clean$n),], 10)

      # top_10 <- word_freq_clean %>% arrange(desc(n)) %>% head(10)

# 19. Create a bar chart showing the number of times the top10 words were used.
ggplot(data = top10, aes(x = word, y = n, fill = word)) + geom_col()

# 20. Run the below to join word_freq with sentiments.
sentiment_freq <- left_join(word_freq, sentiments, by = "word")

# 21. Now explore the data. What is going on?
      # The words which have sentiment are coded to determine the type of sentiment. 

# 22. For the whole survey, were there more negative or positive sentiment words used?
table(sentiment_freq$sentiment) # positive! :D

# 23. Create an object with the number of negative and positive words used for each person.

sentiment_by_person <- left_join(words, sentiments, by = "word")

table(sentiment_by_person$sentiment, sentiment_by_person$first_name)

# 24. In that object, create a new variable named sentimentality, which is the number of positive words minus the number of negative words.

# 25. Make a histogram of senitmentality

# 26. Make a barplot of sentimentality.

# 27. Create a wordcloud for the dream variable.

# 28. Create a barplot showing the top 16 words in our dreams.

# 29. Which word showed up most in people’s description of Joe?

# 30. Make a histogram of feeling_num.

# 31. Make a density chart of feeling_num.

# 32. Change the above plot to facet it by gender.

# 33. How many people mentioned Ryan Gosling in their description of Joe?

# 34. Is there a correlation between the sentimentality of people’s feeling and their feeling_num?

  