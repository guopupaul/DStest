library(gutenbergr)
library(tidyverse)
gutenberg_authors
gutenberg_works(str_detect(title, "Jeeves"))
Right_Ho_Jeeves <- gutenberg_download(10554)
Right_Ho_Jeeves
library(tidytext)
tidy_Right_Ho_Jeeves <- Right_Ho_Jeeves %>%
  unnest_tokens(word, text) %>% #tokenize 
  anti_join(stop_words) #remove stop words
print(tidy_Right_Ho_Jeeves)
tidy_Right_Ho_Jeeves %>% count(word, sort=TRUE)
freq_hist <-tidy_Right_Ho_Jeeves %>%
  count(word, sort=TRUE) %>%
  filter(n > 50) %>%
  mutate(word = reorder(word,n )) %>%
  ggplot(aes(word, n))+
  geom_col(fill= 'lightgreen')+
  xlab(NULL)+
  coord_flip()
print(freq_hist)