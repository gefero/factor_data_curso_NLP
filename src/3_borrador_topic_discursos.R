library(tidytext)
library(tidyverse)
library(stm)

discursos <- read_csv('./data/proc/discursos.csv') %>%
        select(-path) %>%
        mutate(autor = ifelse(is.na(autor), 'Mauricio Macri', autor))
        

discursos_ <- discursos %>%
        select(id, fecha_mes, autor, text)

stop_words <- read_csv('./data/utilities/stop_words_complete.csv') %>% pull()

proc <- textProcessor(discursos_$text, 
                      metadata=discursos %>% select(-id),
                      language='es',
                      customstopwords = stop_words,
                      stem = FALSE
                      )

out <- prepDocuments(proc$documents, 
                     proc$vocab,
                     proc$meta, 
                     lower.thresh = 5)

write_rds(out, './data/proc/discursos_out_for_stm.rds')


topics_stm <- stm(documents = out$documents, 
                       vocab = out$vocab,
                       K = 50, 
                       prevalence = ~fecha_mes + autor,
                       content = ~autor,
                       max.em.its = 75, 
                       data = out$meta,
                       init.type = "Spectral")


write_rds(topics_stm, './models/stm_discursos_50t_fecha_autor.rds')


# https://rpubs.com/chelseyhill/672546
