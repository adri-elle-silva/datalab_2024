# title: "Turning Messy Whale Data Into Clean Whale Data"
# author: "Adri Silva, Kyle Jones, Reiner Adakole-Okopi"
# date: "2024-06-13"
# output: html_document

# set working directory
setwd("../datalab_2024/cleaning_prac/")

# load libraries
library(tidyverse)
library(readr)
library(dplyr)
library(stringr)

# load data
whales_dives <- read_csv("whales_dives.csv")
whales_dives_messy <- read_csv("whales_dives_messy.csv")

# change year '15 to 2015
whales_dives_cleaned <- whales_dives_messy %>% mutate(YEAR = case_when(
  YEAR==(15) ~ 2015,
  TRUE ~ YEAR))   # keep the value unchanged if it doesn't match any condition

# Pad! 
whales_dives_cleaned <- whales_dives_cleaned %>%
  mutate(
    # Change month column to add a 0 in front of single character months
    Month=str_pad(whales_dives_cleaned$Month, width = 2, side = "left", pad = "0"),
    #Change days to add leading 0 if before the 10th of the month.
    Day = str_pad(whales_dives_cleaned$Day, width = 2, side = "left", pad = "0")
  )

# see names of messy columns 
names(whales_dives_cleaned)

# clean names of messy columns
names(whales_dives_cleaned) <- c("species", "behavior", "prey.volume", "prey.depth",
                               "dive.time", "surface.time", "blow.interval",
                               "blow.number", "year", "month", "day", "sit") 
                                # year + month + day + sit = id; need to combine and rename.

                                  # c("Species.ID", "bhvr", "PreyVolume", "PreyDepth", 
                                  # "Dive_Time", "Surfacetime", "Blow.Interval",
                                  # "Blow_number_count","YEAR", "Month","Day","sit")

# removes the word 'sighting' from the sighting number so that we can merge 
whales_dives_cleaned <- whales_dives_cleaned %>% mutate(sit = str_remove(whales_dives_cleaned$sit, "Sighting\\s*")) # the \\s removes the spaces before the number

# make a new column, id! with no spaces. yaaay!
whales_dives_cleaned$id <- paste0(whales_dives_cleaned$year, whales_dives_cleaned$month,
                                   whales_dives_cleaned$day, whales_dives_cleaned$sit)

# make the character a numeric
whales_dives_cleaned$id <- as.numeric(whales_dives_cleaned$id)

# but how to remove columns that we wanted to MERGE...?
whales_dives_cleaned <- subset(whales_dives_cleaned, select = -c(year, month, day, sit))

## remove all rows with NA and then keep distinct observations (aka, removing duplicates)
whales_dives_cleaned <- na.omit(whales_dives_cleaned)
whales_dives_cleaned <- whales_dives_cleaned %>% distinct()

# cut off every character in behavior past the first one (F and O)
whales_dives_cleaned$behavior <- substr(whales_dives_cleaned$behavior, 1, 1)

# rename  F to FEED and O to OTHER to keep 
whales_dives_cleaned <- whales_dives_cleaned %>% mutate(behavior = case_when(
  behavior %in% c("F") ~ "FEED",
  behavior %in% c("O") ~ "OTHER",
  TRUE ~ behavior  # keep the value unchanged if it doesn't match any condition
))



# remove 2 observations that were called finderbender
# because they do not show up in the clean version
whales_dives_cleaned <- whales_dives_cleaned %>% filter(id!=20150915507)
whales_dives_cleaned <- whales_dives_cleaned %>% filter(id!=20150911503)

# correct misspellings in species column
whales_dives_cleaned <- whales_dives_cleaned %>% mutate(species = case_when(
  species == "FinW" ~ "FW",
  species == "FinWhale" ~ "FW",
  species == "Hw" ~ "HW",
  TRUE ~ species  # Keep other values unchanged
))

# find what is not matching
all.equal(whales_dives, whales_dives_cleaned)

#moves id column to the left
whales_dives_cleaned <- whales_dives_cleaned[, c("id", setdiff(names(whales_dives_cleaned), "id"))]

whales_dives_cleaned <- arrange(desc(whales_dives_cleaned$id))
