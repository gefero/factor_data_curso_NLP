library(tidytext)
library(tidyverse)
library(stm)

path <- '/media/grosati/Elements/PEN/Datasets_ML/Discursos/discursos-presidenciales/discursos/'

files <- list.files(path = path, pattern = ".txt", full.names = TRUE, recursive=TRUE)

discursos <- files %>%
        purrr::set_names(nm = (paste0(dirname(.),'/',basename(.)))) %>%
        purrr::map(read_file)


discursos <- discursos %>% 
        map_dfr(~ .x %>% as_tibble(), .id = "name")

discursos <- discursos %>%
        rename(path=name,
               text=value) %>%
        mutate( autor = case_when(
                        grepl('cristina-fernandez-de-kirchner', path) ~ 'Cristina Fernandez de Kirchner',
                        grepl('nestor-kirchner', path) ~ 'Nestor Kirchner',
                        grepl('mauricio-macri', path) ~ 'Mauricio Macri'),
                fecha_str = str_replace_all(str_extract(path, "\\d*_\\d+_\\d*"), '_', '/'),
                fecha_iso = lubridate::ymd(fecha_str),
                fecha_mes = lubridate::format_ISO8601(fecha_iso, precision = "ym"),
                id = row_number(),
        ) %>%
        select(id, path, fecha_str, fecha_iso, fecha_mes, autor, text)

write_csv(discursos, './data/proc/discursos.csv')







