generaTDM <- function(tema, ruta){
  
  # Rellenamos el campo "carpeta" en funci�n del par�metro "tema"  
  
  if (tema=="Adq"){carpeta <- "/acq"} else {carpeta <- "/crude"}
  
  fuente <- paste("C:\Users\Ana Lucia\Desktop\UNIVERSIDAD\Data Science\LAB5\Limpiolimpio.xlsx",carpeta, sep = "")
  # Lectura de los ficheros XML
  ficheros <- Corpus(DirSource(fuente),readerControl=list(reader=readReut21578XMLasPlain))
  
  
  # Inicializamos el vector de caracteres "documentos"  
  documentos <- character(length(ficheros))
  
  # ------------------------------------------------
  # Inicio del proceso de acceso a las noticias Reuters
  # ------------------------------------------------
  for (i in 1:length(ficheros)) {
    # Carga del fichero XML 
    doc.text <- ficheros[[i]]
    # Substituir \n por espacio en blanco
    doc.text <- gsub('\\n', ' ', doc.text)
    doc.text <- gsub('"', ' ', doc.text)
    # Llegados a este punto tenemos cada p�rrafo en un elemento de la lista.
    # A continuaci�n uniremos todos los p�rrafos en un �nico elemento de la lista doc.text
    doc.text <- paste(doc.text, collapse = ' ')    
    documentos[i] <- doc.text
  }
  # ---------------------------------------------
  # Fin del proceso de acceso a las noticias Reuters
  # ---------------------------------------------
  
  # Generamos un corpus con todos los documentos del tema seleccionado
  s.cor <- Corpus(VectorSource(documentos))
  # Aplicamos las tareas de acondicionado de texto previstas en la funci�n acondicionaCorpus
  s.cor.cl <- acondicionaCorpus(s.cor)
  # Generamos una matriz de palabras donde las filas son los documentos y las columnas son las palabras o t�rminos.
  s.tdm <- TermDocumentMatrix(s.cor.cl)
  # Eliminamos las palabras coloquiales que suelen repetirse y que no aportan significado
  s.tdm <- removeSparseTerms(s.tdm, 0.85)
  # Devolvemos una lista donde el primer valor "name" es el Tema de los documentos y el segundo valor "tdm" es la matriz de palabras TDM
  result <- list(name = tema, tdm = s.tdm)
}
library(SnowballC)
# Construimos un bucle sobre los dos Temas y les aplicamos la funci�n generaTDM() pasando como par�metro la ruta de los documentos XML con las noticias Reuters.
tdm <- lapply(temas, generaTDM, ruta = nombreruta)
# Al imprimir la estructura del objeto tdm, observamos c�mo est� compuesta por 2 Matrices de T�rminos: "Adq" y "Crudo"  
str(tdm)

inspect(tdm[[1]]$tdm[1:30,1:10])

# A�adir el Tema a cada documento
unirTemaTDM <- function(tdm){
  # Por un lado guardamos el segundo valor de la lista tdm, es decir, la matriz TDM de t�rminos o palabras.
  # La funci�n t() nos ayudar� a trasponer la matriz, es decir, a intercambiar filas por columnas.
  s.mat <- t(data.matrix(tdm[["tdm"]]))
  # La convertimos a data.frame que vendr�a a ser como un formato excel (filas, columnas y celdas con valores)  
  
  # En este data.frame o excel, tenemos que cada fila es un documento, cada columna una palabra y las celdas contienen la frecuencia en que cada palabra aparece en cada documento.
  s.df <- as.data.frame(s.mat, stringsAsFactors = FALSE)
  # En la �ltima columna colocaremos el Tema de cada documento tdm[["name"]. Para ello usaremos dos funciones cbind() y rep()  
  
  # Recordemos que en la lista tdm hab�amos almacenado el tema en el valor "name"
  # Mediante la funci�n rep() repetiremos el tema del documento tantas veces como filas hay en el data.frame 
  nueva_columna <- rep(tdm[["name"]], nrow(s.df))
  # Recordemos que la funci�n cbind() sirve para concatenar columnas 
  s.df <- cbind(s.df, nueva_columna)
  # Finalmente asignamos un nombre a la �ltima columna para que nos sea m�s f�cil identificarla  
  colnames(s.df)[ncol(s.df)] <- "temaObjetivo"
  return(s.df)
}