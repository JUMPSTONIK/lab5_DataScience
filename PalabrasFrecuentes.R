#Se instalan paquetes si es necesario
if(!require(NLP))
{{install.packages("NLP", dependencies = TRUE)}}

if(!require(tm))
{install.packages("tm", dependencies = TRUE)}

if(!require(SnowballC))
{install.packages("SnowballC", dependencies = TRUE)} 

if(!require(wordcloud))
{install.packages("wordcloud", dependencies = TRUE)} 

if(!require(wordcloud2))
{install.packages("wordcloud2", dependencies = TRUE)} 

if(!require(RColorBrewer))
{install.packages("RColorBrewer", dependencies = TRUE)} 

library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library(readxl)

#Llamar data set
limpio <- read_excel("C:/Users/Ana Lucia/Desktop/UNIVERSIDAD/Data Science/LAB5/Limpiolimpio.xlsx")

text<-limpio$reviews.text
txt<-limpio$reviews.title

#Vuelve el texto un vector
text = iconv(text, to="ASCII//TRANSLIT")
txt = iconv(txt, to="ASCII//TRANSLIT")

#Formato de texto
corpus <- Corpus(VectorSource(text))
crps <- Corpus(VectorSource(txt))

#Matriz de conteo
tdmx <- TermDocumentMatrix(corpus)
tdm <- TermDocumentMatrix(crps)

#Encuentra terminos frecuentes
frecuentes<-findFreqTerms(tdmx, lowfreq=20)
View(frecuentes)

#Guardar terminos frecuentes
write.xlsx(frecuentes, file = "terminosFrecuentes.xlsx", SheetName = "DataLimpia")

#Para lograr convertirlo en matriz
memory.limit(9999999999999)

#Lo vuelve una matriz
m <- as.matrix(tdm)

#Lo ordena y suma
v <- sort(rowSums(m),decreasing=TRUE)

#Lo nombra y le da formato de data.frame
df <- data.frame(word = names(v),freq=v) 

### TRAZAR FRECUENCIA DE PALABRAS
barplot(df[1:10,]$freq, las = 2, names.arg = df[1:10,]$word,
        col ="lightblue", main ="PALABRAS MÁS FRECUENTES", ylab = "Frecuencia de palabras")

###NUBE DE PALABRAS
wordcloud(words = df$word, freq = df$freq, min.freq = 6,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

###NUBE DE PALABRAS DIFERENTE
wordcloud2(df, size=1.2)
