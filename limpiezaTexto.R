#Instalacion de paquetes
install_github('trinker')
install.packages("stopwords")
install.packages("modules")
install.packages('tm')

#Instalacion de librerias
library(dplyr)
library(tidyr)#glimpse
library(stringr)
require(stringi)#gsub
library(tidyselect)#substr
library(readxl)
library('tm')
library(readxl)
library (xlsx)
library("stopwords")
library("modules")

#Llamar data set
DataLab5 <- read_excel("C:/Users/Ana Lucia/Desktop/UNIVERSIDAD/Data Science/LAB5/DataLab5.xlsx")
Review<-(DataLab5)

#Exploracion general de las variables
glimpse(Review)

#Cambio todo a minúsculas
texts <- str_to_lower(Review$reviews.text, locale = "es")
txt <- str_to_lower(Review$reviews.title, locale = "es")

#Eliminación de simbolos
texts  <- gsub("[#-$%&*!.,'+()]"," " , texts ,ignore.case = TRUE)
txt  <- gsub("[#-$%&*!.,'+]"," " , txt ,ignore.case = TRUE)


#Eliminación de espacios en blanco
texts <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", " ",texts, perl=TRUE)

#Eliminacion de URLS
texts <- gsub(pattern = "(http[^[:space:]]*)",
               replacement = " ",
               texts)
txt <- gsub(pattern = "(http[^[:space:]]*)",
              replacement = " ",
              txt)

#Eliminacion de stop words
stopwords = c("husband","times","use","try","bought","got","tried","used","well","made","product","purchased","purchase")
texts <- removeWords(texts,stopwords("english"))
texts <- removeWords(texts,stopwords)

txt <- removeWords(txt,stopwords("english"))
txt <- removeWords(txt,stopwords)

#Hacer stem
texts <- Corpus(VectorSource(texts))
texts <- tm_map(texts, stemDocument, language = "english") 

#Pasarlo a data frame
texts <- data.frame(text=sapply(texts, identity), 
                        stringsAsFactors=F)
#Pasarlo a vector
texts <- as.vector(t(texts))

#Se guardan las columnas en el data set
Review$reviews.text <- texts
Review$reviews.title<-txt

#GUardar documento
write.xlsx(Review, file = "Limpiolimpio.xlsx", SheetName = "DataLimpia")



