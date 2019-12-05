# Exploring the DOJCS prisoner statistics 2007-2018 - Prisoner Age and Imprisonment rate
## Introduction
Corrections Victoria has published its Annual Prisoner Statistical Profile 2007-2018 on the DOJCS website <https://www.corrections.vic.gov.au/publications-manuals-and-statistics/annual-prisoner-statistical-profile-2006-07-to-2017-18>. This consists of tables spread across 36 sheets of an Excel workbook. The profile is not in a tidy data format. The profile aggregates and displays data in many dimensions but it does not provide any visualisation or analysis.

## Cleaning the data - prisoner age
Data regarding prisoner age is in Table 1.5. The code blocks below tidy up the male and female data separately and then join them into one tidy data tibble showing prisoner age across the time period.

Load the following packages:
```{r}
library(stringr)
library(dplyr)
library(readxl)
library(tidyr)
library(ggplot2)
```

Here is the male data read in:
```{r}
male_prisoner_age <- read_excel("annual_prisonerstats_2017-18v2.xls", sheet = 8, range = "B6:AA15",col_names = FALSE)
```
Here is the female data read in:
```{r}
female_prisoner_age <- read_excel("annual_prisonerstats_2017-18v2.xls", sheet = 8, range = "B21:AA30",col_names = FALSE)
```
The code below is a function that tidies the extracted data:
```{r}
tidy_age <- function(x) {
#remove column 2 (blank) and percentage columns
x <- x %>% select(1,3:26) %>% select(c(-3, -5, -7, -9, -11, -13, -15, -17, -19, -21, -23, -25 ))
# label age and dates
colnames(x) <- c("Age", "30/06/07", "30/06/08", "30/06/09", "30/06/10", "30/06/11", "30/06/12", "30/06/13", "30/06/14", "30/06/15", "30/06/16", "30/06/17", "30/06/18")
#transpose rows and columns
x <- x %>% gather("year", "number_of_prisoners", 2:13)
}
```
A tidy data tibble showing male prisoner age across 2007-2018:
```{r}
tidy_male_prisoner_age <- tidy_age(male_prisoner_age)
tidy_male_prisoner_age
```
A tidy data tibble showing female prisoner age across 2007-2018:
```{r}
tidy_female_prisoner_age <- tidy_age(female_prisoner_age)
tidy_female_prisoner_age
```
The code below joins male and female tibbles together:
```{r}
tidy_male_prisoner_age <- tidy_male_prisoner_age %>% mutate(gender = "Male")
tidy_female_prisoner_age <- tidy_female_prisoner_age %>% mutate(gender = "Female")
#join the two tibbles
tidy_prisoner_age <- tidy_male_prisoner_age %>%
bind_rows(tidy_female_prisoner_age) %>%
arrange(year)
#consistent variable names, classes, and column order for presentation
tidy_prisoner_age <- tidy_prisoner_age %>% 
mutate_all(list(~str_replace(.,"Under 20", "0-20" ))) %>% 
mutate_all(list(~str_replace(.,"60 and over", "60-150" ))) 
col_order <- c("Age", "gender", "year", "number_of_prisoners")
tidy_prisoner_age <- tidy_prisoner_age[, col_order]
tidy_prisoner_age$number_of_prisoners <- as.numeric(tidy_prisoner_age$number_of_prisoners)
tidy_prisoner_age$Age <- as.factor(tidy_prisoner_age$Age)
tidy_prisoner_age$gender <- as.factor(tidy_prisoner_age$gender)
tidy_prisoner_age
```
## Cleaning the data - Imprisonment rate
Data regarding Imprisonment Rate is in Table 1.6. The code blocks below tidy up the male and female data separately and then join them into one tidy data tibble showing Imprisonment Rate across the time period.

Here is the male data read in:
```{r}
male_prisoner_rate <- read_excel("annual_prisonerstats_2017-18v2.xls", sheet = 9, range = "B6:O16",col_names = FALSE)
```
Here is the female data read in:
```{r}
female_prisoner_rate <- read_excel("annual_prisonerstats_2017-18v2.xls", sheet = 9, range = "B21:O31",col_names = FALSE)
```
The code below is a function that tidies the extracted data:
```{r}
tidy_rate <- function(x) {
#remove column 2 (blank)
x <- x %>% select(1,3:14)
# label Rate and dates
colnames(x) <- c("Age", "30/06/07", "30/06/08", "30/06/09", "30/06/10", "30/06/11", "30/06/12", "30/06/13", "30/06/14", "30/06/15", "30/06/16", "30/06/17", "30/06/18")
#transpose rows and columns
x <- x %>% gather("year", "rate_per_100K", 2:13)
}
```
A tidy data tibble showing male prisoner Rate across 2007-2018:
```{r}
tidy_male_prisoner_rate <- tidy_rate(male_prisoner_rate)
tidy_male_prisoner_rate
```
A tidy data tibble showing female prisoner Rate across 2007-2018:
```{r}
tidy_female_prisoner_rate <- tidy_rate(female_prisoner_rate)
tidy_female_prisoner_rate
```
The code below joins male and female tibbles together:
```{r}
tidy_male_prisoner_rate <- tidy_male_prisoner_rate %>% mutate(gender = "Male")
tidy_female_prisoner_rate <- tidy_female_prisoner_rate %>% mutate(gender = "Female")
#join the two tibbles
tidy_prisoner_rate <- tidy_male_prisoner_rate %>%
bind_rows(tidy_female_prisoner_rate) %>%
arrange(year)
#consistent variable names, classes, and column order for presentation
tidy_prisoner_rate <- tidy_prisoner_rate %>% 
mutate_all(list(~str_replace(.,"Under 20", "0-20" ))) %>% 
mutate_all(list(~str_replace(.,"65 and over", "65-150" ))) 
col_order <- c("Age", "gender", "year", "rate_per_100,000")
tidy_prisoner_rate <- tidy_prisoner_rate[, col_order]
tidy_prisoner_rate$rate_per_100K <- as.numeric(tidy_prisoner_rate$rate_per_100K)
tidy_prisoner_rate$Age <- as.factor(tidy_prisoner_rate$Age)
tidy_prisoner_rate$gender <- as.factor(tidy_prisoner_rate$gender)
tidy_prisoner_rate
```
## Consolidating Age and Imprisonment rate data
For reasons unknown, the age bin values in "Prisoner Age"" stop at 60 and stop at 65 in "Imprisonment Rate".





