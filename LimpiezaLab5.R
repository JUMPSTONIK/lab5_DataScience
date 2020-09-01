library(stringi)
library(dplyr)
library(qdapRegex)
install.packages("qdapRegex")
install.packages("stopwords")
library("stopwords")
library('tm')
library(xlsx)
#pacman::p_load_gh("trinker/qdapRegex")
#setwd("~/Documents")
#obtener la data y visualizarla
#dataLimp <- read.xlsx2('Datalab5.xlsx')
head(DataLab5)
str(DataLab5)

#volver todo a minuscula
brand <- sapply(DataLab5$brand, tolower)
manufact <- sapply(DataLab5$manufacturer, tolower)
reviewsText <- sapply(DataLab5$reviews.text, tolower)
reviewTitle <- sapply(DataLab5$reviews.title, tolower)
user <- sapply(DataLab5$reviews.username, tolower)

#eliminar caracteres especiales y de puntuacion
reviewsText <-  gsub("[[:punct:]]", "",reviewsText)
reviewTitle <-  gsub("[[:punct:]]", "",reviewTitle)

#eliminar emoticones
reviewsText <- gsub("[^\x01-\x7F]", "", reviewsText)
reviewTitle <- gsub("[^\x01-\x7F]", "",reviewTitle)

#eliminar stopwords
reviewsText <- removeWords(reviewsText,stopwords("english"))
reviewTitle <- removeWords(reviewTitle,stopwords("english"))

#remover numeros incecesarios
reviewsText <- gsub('[[:digit:]]+', '', reviewsText)
reviewTitle <- gsub('[[:digit:]]+', '', reviewTitle)

#Eliminacion de URLS
reviewsText <- gsub(pattern = "(http[^[:space:]]*)", replacement = " ", reviewsText)

#eliminar espacios en blanco muy repetidos
reviewsText <- gsub(pattern = "  ", replacement = " ", reviewsText) #se repite al menos 3 veces para eliminar los muchso espacios en blanco
reviewTitle <- gsub(pattern = "  ", replacement = " ", reviewTitle) #lo mismo aca
user <- gsub(pattern = "\\s", replacement = "", user) #lo mismo aca

#asignar las variables al DataLab5

DataLab5$brand <- brand
DataLab5$manufacturer <- manufact
DataLab5$reviews.text <- reviewsText
DataLab5$reviews.title <- reviewTitle
DataLab5$reviews.username <- user

#examinando duplicados
distinct(DataLab5)
duplicated(DataLab5)
nrow(DataLab5[duplicated(DataLab5), ])
DataLab5 <- distinct(DataLab5)

options(PACKAGE_MAINFOLDER="C:/Users/...")
options(java.parameters = "-Xmx8000m")
 
#Guardar el csv
write.csv(x=DataLab5, file= "C:/Users/JUMPSTONIK/DataClean.csv")
