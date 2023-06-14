# Se cargan los paquetes. 

library(move)
library(adehabitatHR)
library(sf)
library(moveVis)
library(sp)
library(ggplot2)
library(dplyr)
library(lubridate)
library(mapview)

# Se va a utilizar el marco de datos buffalo del paquete adehabitatHR.
?buffalo
data("buffalo")

# Se extrae de la lista el marco de datos con la información espaciotemporal. 
# Se seleccionan las columnas de las coordenadas x e y, y la fecha.
buffaloData <- buffalo[["traj"]][[1]] %>% dplyr::select(x, y, date)

# Se convierte la colunmna de las fechas en la clase POSIXct
buffaloData$date <- as.POSIXct(buffaloData$date, format = "%Y-%m-%d %hh:%mm:%ss")
# Otra columna que no tenga información sobre el momento del día, simplemente la fecha.
buffaloData$day <-  as.Date(buffaloData$date)

# Es ncesario conocer la proyección. Para ello se toma un par de coordenadas xy.
buffaloData$x[1]
buffaloData$y[1]
# Se introducen en la siguiente web: https://www.geoplaner.com/
# Sale que cae en la "zone 32N (wgs84)".
# Se busca en la página https://spatialreference.org/ref/epsg/
# La referencia epsg para WGS84 zone 32N.
# Esto arroja el resultado siguiente: https://spatialreference.org/ref/epsg/?search=zone+32N+wgs84&srtext=Search
# Y nos interesa: https://spatialreference.org/ref/epsg/32432/
# Es decir, la referencia a la proyección CRS es 32632. 

# Se obtiene el objeto espacial UTM. Se diferencia del de latitud-longitud
# en que trabaja y devuelve la salida en metros y no en grados. Así, 
# el objeto UTM es útil para hacer cálculos y trabajos no relacionados con 
# graficar, mientras que el objeto latitud-longitud sirve para trazar mapas.
buffalospUTM <- SpatialPoints(cbind(buffaloData$y, buffaloData$x),
                              proj4string = CRS("+init=epsg:32632"))
# Se transforma el objeto UTM en uno de latitud-longitud y se guarda en otra variable.
buffalospLatLong <- spTransform(buffalospUTM,
                                CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))

# Se mapea el objeto espacial creado. 
mapView(buffalospLatLong, map.types = "OpenTopoMap")

# Se definen la latitud y longitud como un marco de datos. 
buffalospLatLongDF <- as.data.frame(buffalospLatLong)
# Se añaden al marco de datos. 
buffaloData$latitude <- buffalospLatLongDF$coords.x1
buffaloData$longitude <- buffalospLatLongDF$coords.x2

# Obtener el rango temporal.
dateRange <- paste0(min(buffaloData$day), "_to_", max(buffaloData$day))
dateRange

# Número de movimientos.
movesNumber <- length(buffaloData$day)
movesNumber

# Número de días total en los que se registra movimiento. 
moveDaysNumber <- length(unique(buffaloData$day))
moveDaysNumber

# Se vectorizan los datos espaciales transformando el objeto UTM en un marco de datos.
buffaloUTMDF <- as.data.frame(buffalospUTM)

# Cálculo de las distancias. 
distances <- NULL
for(i in 2:length(buffaloData$date)){
  
  distance <- sqrt((buffaloUTMDF$coords.x1[i] - buffaloUTMDF$coords.x1[i - 1])^2 +
              (buffaloUTMDF$coords.x2[i] - buffaloUTMDF$coords.x2[i - 1])^2)
  
  distances <- c(distances, distance)
  
}
# Se miran las distancias calculadas. 
distances

# Se mira la distancia total recorrida.
totalDistance <- sum(distances)
totalDistance

# Distancia media recorrida.
avgDistance <- mean(distances)
avgDistance
# Es lo mismo que:
totalDistance/movesNumber

# Se obtiene un vector con las fechas.
dates <- buffaloData$day
dates <- na.omit(dates)
# Se mira el número de días en el que se han tomado medidas.
# Para ello se calcula el rango del vector creado. 
daysRange <- as.numeric(max(dates)-min(dates))
daysRange

# Se calcula la media de la distancia recorrida por día. 
avgDistanceDay <- totalDistance/moveDaysNumber
avgDistanceDay

# Se agrupan los resultados en una lista.
resultsList <- list("moveDaysNumber", "movesNumber", "totalDistance",
                    "avgDistance", "avgDistanceDay")



addResult <- function(mylist){
  
  output <- data.frame()
  resultreal<- vector(mode = "numeric") 
  
  for (result in mylist){
    if(exists(result)){
    
      resultreal <- get(result)
      resultreal <- cbind(result, resultreal)
      output <- rbind(output, resultreal)

    }
  }
  
  output 
  
}

resultsdf <- data.frame(addResult(resultsList))
colnames(resultsdf) <- c("Summary Type", "Result")
resultsdf
write.csv(resultsdf, "results/movementDynamicsSummary.csv")


# Se procede a realizar un análisis gráfico. 
# Primero se extrae el nombre completo del mes y se define en una nueva columna.
buffaloData$month <- format(buffaloData$day, format = "%B")
# También se adjunta el vector de las distancias calculadas. 
buffaloData$distances <- c(0, distances)
# Para trazar posteriormente la progresión de la distancia recorrida
# se calcula el vector de la distancia acumulada. 
buffaloData$sumdistances <- cumsum(buffaloData$distances)
# Se guarda el marco de datos limpio en la carpeta results. 
write.csv(buffaloData, "results/buffaloData.csv")

# Se grafica la distancia recorrida acumulada en virtud del tiempo. 
ggplot(buffaloData, aes(x = day, y = sumdistances, col = month)) +
  geom_line() +
  geom_point() +
  labs(x = "", y = "Distancia  Recorrida  Acumulada", col = "Mes") +
  theme_minimal() +
  theme(legend.position = "none",
              axis.title.y = element_text(size = 9.5, face = "bold",
                                          margin = margin(r = 10)))

# Se comparan los meses. 
ggplot(buffaloData, aes(x = day, y = sumdistances)) +
  geom_line(linetype="dotdash", col = "purple4", size = 0.7) +
  labs(x = "", y = "Distancia  Recorrida  Acumulada") +
  facet_wrap(~month, scales = "free") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 9.5, face = "bold",
                                    margin = margin(r = 20)))




