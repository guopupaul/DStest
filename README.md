# Exploring the DOJCS prisoner statistics 2007-2018
## Introduction
Corrections Victoria has published its Annual Prisoner Statistical Profile 2007-2018 on the DOJCS website <https://www.corrections.vic.gov.au/publications-manuals-and-statistics/annual-prisoner-statistical-profile-2006-07-to-2017-18>. This consists of tables spread across 36 sheets of an Excel workbook. The profile is not in a tidy data format. The profile aggregates and summarises data in many dimensions but it does not provide any visualisation or analysis.

## Prisoner Age
Data regarding prisoner age is in Table 1.5. The code blocks below tidy up the male and female data separately and then join them into one tidy data tibble showing prisoner age across the time period.

Here is the male data read in:
```{r}
library(stringr)
library(dplyr)
library(readxl)
library(tidyr)
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
tidy_prisoner_age <- tidy_male_prisoner_age %>%
bind_rows(tidy_female_prisoner_age) %>%
arrange(year)
tidy_prisoner_age
```






