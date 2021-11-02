![](/imgs/logo-factor-data-solo.jpg)

## Docentes

- [Germán Rosati](https://gefero.github.io/)
- [Laia Domenech]()

# Presentación
El trabajo empírico en las ciencias sociales se caracteriza por su gran diversidad en el tipo de fuentes de información utilizadas: desde datos altamente estructurados (cuya forma más clásica son las encuestas) hasta datos de un grado menor de estructuración. En este último grupo, los datos textuales, ya se trate de documentos, noticias, entrevistas, etc.- ocupan un lugar central.

En las ciencias sociales argentinas el análisis de textos parece haber estado centrado fundamentalmente en técnicas de "lectura profunda", una lectura manual, interpretativa, con gran detalle de corpus pequeños, buscando entender todos los matices de cada documento. Es por ello que este seminario propone como complemento una aproximación desde una "lectura distante" centrada en corpus textuales más grandes y que intenta aproximarse, mediante técnicas computacionales a un análisis de tendencias y patrones generales.


# Contenidos y materiales
## Clase 1. Introducción a R y al tidyverse y a tidytext. ¿Cómo hacer de un corpus de texto crudo algo analizable mediante métodos cuantitativos? Preprocesamiento de texto: stopwords, lemmas y stemming. 

- [Explicación y práctica - Notebook](/clase1/notebooks/clase_1.nb.html)
- [Explicación y práctica - RMarkdown](/clase1/notebooks/clase_1.Rmd)
- [Slides - pdf](/clase1/DIPLO_TM_Clase_1.pdf)

Pueden descargarse la totalidad de los materiales del repositorio para trabajar en un único archivo .zip

[![](imgs/Download.png)](clase1.zip)


## Clase 2. ¿Cómo vectorizar textos? Contando palabras y extrayendo conclusiones de un corpus. Bag of Words. Term-frequency matrix: conteos crudos y ponderación TF-IDF. Análisis de sentimientos sobre un corpus. 
- [Sentiment Analysis - Explicación y práctica - Notebook](/clase2/notebooks/2_sentimient_analysis.nb.html)
- [Sentiment Analysis - Explicación y práctica - RMarkdown](/clase2/notebooks/2_sentimient_analysis.Rmd)
- [TF-IDF - Explicación y práctica - Notebook](/clase2/notebooks/21_tfidf.nb.html)
- [TF-IDF - Explicación y práctica - RMarkdown](/clase2/notebooks/21_tfidf.Rmd)
- [Slides - pdf](/clase2/DIPLO_TM_Clase_2.pdf)

Pueden descargarse la totalidad de los materiales del repositorio para trabajar en un único archivo .zip

[![](imgs/Download.png)](clase2.zip)


## Clase 3. Web Scraping


## Clase 4. ¿Cómo detectar temas en corpus I? Introducción al modelado de tópicos. Latent Semantic Analysis (LSA) y Latent Dirichlet Allocation (LDA)


## Clase 5. ¿Cómo detectar temas en corpus II? Un modelo para detectar tópicos diseñado para las ciencias sociales: Structural Topic Modeling.


## Clase 6. Cómo vectorizar textos (recargado)? Una introducción a los métodos de word-embeddings (doc2vec y FastText). Cierre del módulo


# Librerías a utilizar
El taller se desarrollará en R y se hará un uso extensivo de las siguientes librerías:

- `tidytext`
- `topicmodels`

Pueden instalarse utilizando las instrucciones:

```{r}
install.packages('tidytext')
install.packages('topicmodels') 
```


# Bibliografía y sitios de consulta

- Moretti, Franco (2015). Lectura distante. Buenos Aires: Fondo de Cultura Económica.
- Roberts, Margaret; Stewart, Brandon y Tinlgey, Dustin (2016). “stm: R Package for Structural Topic Models”, disponible [aquí](https://cran.r-project.org/web/packages/stm/vignettes/stmVignette.pdf)
- Silge, Julia (2020). Text mining with R. A tidy approach. California: O’Reilly Media. [Versión online gratis en ingles](https://www.tidytextmining.com/) 


