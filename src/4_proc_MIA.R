library(tidyverse)

df <- read_delim('./data/raw/0_MIA_textos_limpios.csv', delim=";")


df %>%
        group_by(autor) %>%
        summarise(n=n()) %>%
        arrange(desc(n))


df %>%
        filter(autor %in% c('rosa luxemburgo', 'lenin')) %>%
        write_csv('./clase1/data/lenin_luxemburgo.csv')
