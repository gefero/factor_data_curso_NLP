# limpiar puntuación
# limpiar numeros
# limpiar stopwords

library(tidytext)
library(tidyverse)

renzi <- read_csv('./data/proc/renzi.csv') %>%
        mutate(tomo = case_when(
                tomo == '1_diarios_renzi_años_de_formacion.txt' ~ 'I-Años de formación',
                tomo == '2_diarios_renzi_los_años_felices.txt' ~ 'II-Los años felices',
                tomo == '3_diarios_renzi_un_dia_en_la_vida.txt' ~ 'III-Un día en la vida',
        ))


## Funciones auxiliares

get_stopwords <- function(){
        custom_stop_words <- bind_rows(stop_words,
                                       tibble(word = tm::stopwords("spanish"),
                                              lexicon = "custom"))
        
        
        custom_stop_words <- bind_rows(custom_stop_words,
                                       tibble(word = quanteda::stopwords(language = 'es'),
                                                  lexicon = "custom"))
        
        custom_stop_words <- custom_stop_words %>%
                add_row(word='si', lexicon='custom')
        
        return(custom_stop_words)
}

get_sentiment_spanish <- function(corpus='kaggle'){
        
        if (corpus=='kaggle'){
                positive_words <- read_csv('./data/utilities/kaggle_positive_words_es.txt',col_names = 'word') %>%
                        mutate(sentiment='positivo')
                negative_words <- read_csv('./data/utilities/kaggle_negative_words_es.txt', col_names = 'word') %>%
                        mutate(sentiment='negativo')
                
                sentiment_words <- bind_rows(positive_words, negative_words)
                return(sentiment_words)
                
        }
        if (corpus=='liia'){
                
                df <- read_delim('./data/utilities/liia_meanAndStdev.csv', delim=";", 
                                 col_names=FALSE) %>%
                        rename(word=X1,
                               mean_likeness=X2,
                               mean_activation=X3,
                               mean_imaginability=X4,
                               std_likeness=X5,
                               std_activation=X6,
                               std_imaginability=X7
                        ) %>%
                        mutate(word=str_remove_all(word, "_\\w*")) %>%
                        select(word, mean_likeness, std_likeness)
                return(df)
        }
}


#####

tidy_renzi <- renzi %>%
        mutate(entry_number = row_number()) %>%
        #group_by(chapter) %>%
        unnest_tokens(word, entry)

custom_stop_words <- get_stopwords() %>%
        write_csv('./data/utilities/stop_words_complete.csv')

tidy_renzi <- tidy_renzi %>%
        anti_join(custom_stop_words)


sentiment_words_kaggle <- get_sentiment_spanish() %>%
                                write_csv('./data/utilities/sentiment_lexicon_kaggle.csv')

sentiment_words_liia <- get_sentiment_spanish('liia') %>%
                                write_csv('./data/utilities/sentiment_lexicon_liia.csv')

sentiment_words_liia <- sentiment_words_liia %>%
        mutate(sentiment = case_when(
                round(mean_likeness) == 1 ~ 'negativo',
                round(mean_likeness) == 2 ~ 'neutral',
                round(mean_likeness) == 3 ~ 'positivo',
        ))

tidy_renzi_sent_kag <- tidy_renzi %>%
        inner_join(sentiment_words_kaggle) %>%
        count(tomo, index=entry_number, sentiment) %>%
        pivot_wider(names_from=sentiment, 
                    values_from=n,
                    values_fill=0) %>%
        mutate(sentiment = positivo - negativo)


tidy_renzi_sent_liia_1 <- tidy_renzi %>%
        inner_join(sentiment_words_liia) %>%
        count(tomo, index=entry_number, sentiment) %>%
        pivot_wider(names_from=sentiment, 
                    values_from=n,
                    values_fill=0) %>%
        mutate(sentiment = positivo - negativo)

tidy_renzi_sent_liia <- tidy_renzi %>%
        inner_join(sentiment_words_liia) %>%
        group_by(tomo, entry_number) %>%
        summarise(likeness_mean = mean(mean_likeness))


ggplot(tidy_renzi_sent_kag, aes(index, sentiment, color=tomo)) +
        geom_line(show.legend = TRUE) +
        #geom_smooth(aes(index, sentiment, color=tomo)) +
        labs(x='Entrada del diario',
             y= 'Sentimiento (palabras positivas-palabras negativas)',
             title='Análisis de sentimiento por palabras (lexicon Kaggle)') +
        theme_minimal() +
        scale_color_viridis_d() +
        theme(
                axis.title.x=element_blank(),
                axis.text.x=element_blank(),
                axis.ticks.x=element_blank(),
                legend.position = 'bottom')


ggplot(tidy_renzi_sent_liia_1, aes(index, sentiment, color=tomo)) +
        geom_line() +
        #geom_smooth(ae s(index, sentiment, color=tomo)) +
        labs(x='Entrada del diario',
             y= 'Sentimiento (palabras positivas-palabras negativas)',
             title='Análisis de sentimiento por palabras (lexicon LIIA tricomotizado)') +
        theme_minimal() +
        scale_color_viridis_d() +
        theme(
                axis.title.x=element_blank(),
                axis.text.x=element_blank(),
                axis.ticks.x=element_blank(),
                legend.position = 'bottom')



ggplot(tidy_renzi_sent_liia, aes(entry_number, likeness_mean, color=tomo)) +
        geom_line(show.legend = FALSE) +
       # geom_smooth(aes(entry_number, likeness_mean)) +
        labs(x='Entrada del diario',
             y= 'Sentimiento (palabras positivas-palabras negativas)',
             title='Análisis de sentimiento por palabras (lexicon LIIA crudo)') +
        theme_minimal() +
        scale_color_viridis_d() +
        theme(
                axis.title.x=element_blank(),
                axis.text.x=element_blank(),
                axis.ticks.x=element_blank(),
                legend.position = 'bottom')



ggplot(tidy_renzi_sent_kag, aes(index, sentiment, color=tomo, fill=tomo)) +
        #geom_line(show.legend = FALSE) +
        geom_smooth(aes(index, sentiment, color=tomo)) +
        labs(x='Entrada del diario',
             y= 'Sentimiento (palabras positivas-palabras negativas)',
             title='Análisis de sentimiento por palabras suavizado GAM (lexicon Kaggle)') +
        theme_minimal() +
        scale_color_viridis_d() +
        theme(
                axis.title.x=element_blank(),
                axis.text.x=element_blank(),
                axis.ticks.x=element_blank(),
                legend.position = 'bottom')


ggplot(tidy_renzi_sent_liia, aes(entry_number, likeness_mean, color=tomo, 
                                 )) +
        #geom_line(show.legend = FALSE) +
        geom_smooth(aes(entry_number, likeness_mean)) +
        labs(x='Entrada del diario',
             y= 'Sentimiento (palabras positivas-palabras negativas)',
             title='Análisis de sentimiento por palabras suavizado GAM (lexicon LIIA)') +
        scale_color_viridis_d() +
        theme(
                axis.title.x=element_blank(),
                axis.text.x=element_blank(),
                axis.ticks.x=element_blank(),
                legend.position = 'bottom')

