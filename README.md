# Cleaning the DOJCS prisoner statistics 2007-2018
Key data is in Tables 1.5, .....
For table 1.5, my aim is to tidy up the male and female data separately and then join them into one tidy data tibble showing prisoner age across the time period
```{r}
library(stringr)
library(dplyr)
library(readxl)
male_prisoner_age <- read_excel("annual_prisonerstats_2017-18v2.xls", sheet = 8, range = "B4:AA15",col_names = TRUE)
tidy_age <- function(x) {
#remove row 1 (blank)
x <- x %>% slice(2:13)
#remove column 2 (blank) and percentage columns
x <- x %>% select(1,3:26) %>% select(c(-3, -5, -7, -9, -11, -13, -15, -17, -19, -21, -23, -25 )) %>% rename(...1 = "Age")
}


