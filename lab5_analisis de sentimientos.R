library(stringi)
library(dplyr)
library(xlsx)
library(readxl)
require(tm)
library(tidyverse)
library(tidytext)
library(wordcloud)
library(data.table)
library(ggplot2) # Plot word frequencies.
library(sentimentr)
#install.packages(c("wordcloud", "RColorBrewer"))
DataClean <- read_excel("DataClean.xlsx")

#preparamos para generar la nube de palabras
vacias <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnaText/master/datos/diccionarios/vacias.txt",
                   locale = default_locale())
texto_analisis <- tibble(texto = DataClean$reviews.text)

texto_analisis %>%
  unnest_tokens(palabra, texto) %>%
  anti_join(vacias) %>%
  count(palabra, sort = T) %>%
  with(wordcloud(palabra,
                 n,
                 max.words = 100,
                 color = brewer.pal(8, "Dark2")))

#analisis de las palabras negativas y positivas
#con esta linea podemos obtener un dataset con las palabras negativas, positivas y nuetrales encontradas por la libreria de Sentimentr
terms <- extract_sentiment_terms(DataClean$reviews.text)
#view(terms)
#aqui analizamos si el nivel de postividad o negatividad de los comentarios
sentimientos <- sentiment(DataClean$reviews.title)
#view(sentimientos)

#aqui estan los top 10 comentarios
TopBest <- setDT(sentimientos)[order(-sentiment), .SD[1:10]]
DataClean$reviews.text[TopBest$element_id[1]-1]
DataClean$reviews.text[TopBest$element_id[2]-1]
DataClean$reviews.text[TopBest$element_id[3]-1]
DataClean$reviews.text[TopBest$element_id[4]-1]
DataClean$reviews.text[TopBest$element_id[5]-1]
DataClean$reviews.text[TopBest$element_id[6]-1]
DataClean$reviews.text[TopBest$element_id[7]-1]
DataClean$reviews.text[TopBest$element_id[8]-1]
DataClean$reviews.text[TopBest$element_id[9]-1]
DataClean$reviews.text[TopBest$element_id[10]-1]

#aqui esta el top 10 de los peroes comentarios
TopWorst <- setDT(sentimientos)[order(+sentiment), .SD[1:10]]
TopWorst
DataClean$reviews.text[TopWorst$element_id[1]-1]
DataClean$reviews.text[TopWorst$element_id[2]]
DataClean$reviews.text[TopWorst$element_id[3]]
DataClean$reviews.text[TopWorst$element_id[4]]
DataClean$reviews.text[TopWorst$element_id[5]-1]
DataClean$reviews.text[TopWorst$element_id[6]-1]
DataClean$reviews.text[TopWorst$element_id[7]-1]
DataClean$reviews.text[TopWorst$element_id[8]-1]
DataClean$reviews.text[TopWorst$element_id[9]-1]
DataClean$reviews.text[TopWorst$element_id[10]-1]