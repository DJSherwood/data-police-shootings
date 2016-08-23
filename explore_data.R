library(lubridate)
library(ggplot2)
library(dplyr)
library(tidyr)

## Read in Data
df <- read.csv(
        file = paste0(getwd(),"/fatal-police-shootings-data.csv"),
        header = TRUE,
        sep = ",",
        strip.white = TRUE 
)

summary(df)

## Basic questions
## How many events did each state have? 
barplot(sort(table(df$state),decreasing=TRUE))

## Are the distributions of ages Different for M/F? 
## What about Race? 
ggplot(data = df, aes( x = factor(gender), y = age)) + 
        geom_boxplot(aes(fill=gender)) + 
        facet_grid(. ~ race)

## Create Time features
df$month <- month(df$date)
df$day <- day(df$date)
df$year <- year(df$date)

df <- df %>% 
        group_by(state) %>% 
        mutate(week.interval.by.state = (max(ymd(date))-min(ymd(date)))/dweeks(1)) %>% 
        mutate(week.count.by.state = n()) %>% 
        mutate(week.rate.by.state = round(week.count.by.state/week.interval.by.state),2) %>%
        mutate(week.freq.by.state = round(week.interval.by.state/week.count.by.state),2) %>% 
        arrange(state,date) %>%
        ungroup

A <- unique(df[,c("state","week.freq.by.state")]) %>%
        arrange(week.freq.by.state) %>% 

barplot(
        height = A$week.freq.by.state,
        names.arg=A$state,
        main = "Number of weeks that pass between shootings"
        )
        
        