library(tidyverse)

revistas <- read_csv('../Revistas HyM/data/revistas_limpias.csv')

revistas <- revistas %>% 
        select(`data-notaid`, `data-categoriaid`, date, `data-titulo`, text) %>%
        rename(id = `data-notaid`,
               categoria = `data-categoriaid`,
               fecha = date,
               titulo = `data-titulo`,
               text = text)

revistas <- revistas %>%
        mutate(id = row_number())


write_csv(revistas, './clase_4/data/revistas_limpias_final.csv')
