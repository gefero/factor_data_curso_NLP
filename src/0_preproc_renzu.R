library(tidytext)
library(tidyverse)

all_txts <- list.files(path='./data/raw/', pattern = ".txt$", full.names = TRUE )

piglia <- map_df(all_txts, ~ tibble(raw_text = read_file(.x)) %>%
               mutate(tomo = basename(.x))) %>%
        select(tomo, raw_text)
# 
# piglia %>%
#         mutate()
#         unnest_tokens(
#                 output = entry,
#                 input = raw_text,
#                 drop=TRUE,
#                 token = "regex", 
#                 pattern = "\nLunes|Martes|Miércoles|Jueves|Viernes|Sábado|Domingo\\s*\\d*\\s*") %>%
#         nrow()


piglia_lines <- piglia %>%
        group_by(tomo) %>%
        unnest_tokens(token,
                      raw_text,
                      drop=TRUE,
                      token='lines') %>%
        ungroup()




piglia_lines <- piglia_lines %>%
        group_by(tomo) %>%
        mutate(
                chapter = case_when(
                tomo == '1_diarios_renzi_años_de_formacion.txt' ~ cumsum(str_detect(token, regex("(capitulo \\d*.)", 
                                                                                ignore_case = TRUE))),
                TRUE ~ cumsum(str_detect(token, regex("(diario 19\\d\\d)|
                                         (\\(19\\d\\d-19\\d\\d\\))|
                                         (\\(19\\d\\d\\))", ignore_case = TRUE))))) %>%
        ungroup() %>%
        select(tomo, chapter, token)


piglia_chapter <- piglia_lines %>% 
        group_by(tomo, chapter) %>% 
        summarize(text = str_c(token, collapse = " ")) %>%
        ungroup()

piglia_chapter <- piglia_chapter %>%
        filter(chapter!='0')


piglia_entry <- piglia_chapter %>%
        unnest_tokens(
                output = entry,
                input = text,
                drop=TRUE,
                token = "regex", 
                pattern = 
                "(\nlunes|martes|miércoles|jueves|viernes|sábado|domingo\\s*\\d*\\s*)|
                (\nlunes|martes|miércoles|jueves|viernes|sábado|domingo)")


write_csv(piglia_entry, './data/proc/renzi.csv')
