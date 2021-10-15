library(tidyverse)

df <- read_delim('./data/raw/0_MIA_textos_limpios.csv', delim=";")


df %>%
        group_by(autor) %>%
        summarise(n=n()) %>%
        arrange(desc(n))


df %>%
        filter(autor %in% c('Rosa Luxemburgo', 'lenin')) %>%
        group_by(autor) %>%
        sample_n(46) %>%
        write_csv('./clase1/data/lenin_luxemburgo.csv')
