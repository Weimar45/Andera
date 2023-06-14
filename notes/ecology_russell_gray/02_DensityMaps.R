library(dplyr)
library(raster)
library(sp)
library(usdm)
library(mapview)
library(rgbif)
library(scrubr)
library(GISTools)
library(maps)
library(ggplot2)
library(RColorBrewer)
library(ggspatial)
library(cowplot)

# Se hace el mismo workflow para Trimesurus que el realizado para la pitón. 
family <- name_suggest(q = "Trimeresurus", rank = "genus")
occTrimeresurus <- occ_search(taxonKey = family$data$key)
occTrimeresurus$meta$count

data <- occTrimeresurus$data
data <- data %>% dplyr::select(species, decimalLongitude, decimalLatitude)
colnames(data) <- c("species", "longitude", "latitude")
data <- na.omit(data)
data <- dframe(data) %>% coord_impossible() %>% coord_unlikely()
spdata <- SpatialPoints(coords = cbind(data$longitude, data$latitude),
                        proj4string = CRS("+init=epsg:4326"))
spdata$species <- data$species

mapView(spdata, map.types = "OpenTopoMap", layer.name = "species", alpha = 0.7)

# La mayor parte de especies se encuentra en el sur de Asia.
# Luego se centra el foco de atención en éstas.
# Se eligen los países de tales territorios. 
# Los archivos quedan cargados en tu directorio. 
?getData
thailand <- getData("GADM", country = "THA", level = 0)
malasya <- getData("GADM", country = "MYS", level = 0)
indonesia <- getData("GADM", country = "IDN", level = 0)
cambodia <- getData("GADM", country = "KHM", level = 0)
vietnam <- getData("GADM", country = "VNM", level = 0)
myanmar <- getData("GADM", country = "MMR", level = 0)
laos <- getData("GADM", country = "LAO", level = 0)

# Se verifica que la proyección CRS de los archivos descargados es la misma
# que la del objeto espacial creado. 
proj4string(thailand) <- projection(spdata)
proj4string(malasya) <- projection(spdata)
proj4string(indonesia) <- projection(spdata)
proj4string(cambodia) <- projection(spdata)
proj4string(vietnam) <- projection(spdata)
proj4string(myanmar) <- projection(spdata)
proj4string(laos) <- projection(spdata)

# Si se grafican los países ha de salir su forma. 
plot(thailand, main = "Tailandia")
thailandplot <- recordPlot()
plot(malasya, main = "Malasia")
malasyaplot <- recordPlot()
plot(indonesia, main = "Indonesia")
indonesiaplot <- recordPlot()
plot(cambodia, main = "Camboya")
cambodiaplot <- recordPlot()
plot(vietnam, main = "Vietnam")
vietnamplot <- recordPlot()
plot(myanmar, main = "Myanmar")
myanmarplot <- recordPlot()
plot(laos, main = "Laos")
laosplot <- recordPlot()

plot_grid(thailandplot, malasyaplot, labels = "AUTO")
plot_grid(indonesiaplot, cambodiaplot, vietnamplot, labels = "AUTO", nrow = 1)  
plot_grid(myanmarplot, laosplot, labels = "AUTO")


# A continuación, se realiza un conteo de los puntos espaciales 
# que contiene nuestro objeto espacial en cada una de las regiones. 

countsThailand <- poly.counts(spdata, thailand)
countsMalasya <- poly.counts(spdata, malasya)
countsIndonesia <- poly.counts(spdata, indonesia)
countsCambodia <- poly.counts(spdata, cambodia)
countsVietnam <- poly.counts(spdata, vietnam)
countsMyanmar <- poly.counts(spdata, myanmar)
countsLaos <- poly.counts(spdata, laos)

# Se calcula el área de cada polígono en km2
# La función area lo devuelve en metros cuadrados. 
areaThailand <- raster::area(thailand)/10^6
areaMalasya <- raster::area(malasya)/10^6
areaIndonesia <- raster::area(indonesia)/10^6
areaCambodia <- raster::area(cambodia)/10^6
areaVietnam <- raster::area(vietnam)/10^6
areaMyanmar <- raster::area(myanmar)/10^6
areaLaos <- raster::area(laos)/10^6


# Se calcula la densidad de los sujetos en función del área del país. 
densityThailand <- countsThailand/areaThailand
densityMalasya <- countsMalasya/areaMalasya
densityIndonesia <- countsIndonesia/areaIndonesia
densityCambodia <- countsCambodia/areaCambodia
densityVietnam <- countsVietnam/areaVietnam
densityMyanmar <- countsMyanmar/areaMyanmar
densityLaos <- countsLaos/areaLaos

# Se crea un marco de datos con los países y sus densidades.
countries <- c("Thailand", "Malasya", "Indonesia", 
               "Cambodia", "Vietnam", "Myanmar", "Laos")
densities <- c(densityThailand, densityMalasya, densityIndonesia,
               densityCambodia, densityVietnam, densityMyanmar,
               densityLaos)
densitiesDF <- data.frame(countries, densities)
View(densitiesDF)

# Se calcula el porcentaje que cada densidad tiene en cada país.
densitiesDF$percentage <- round(densitiesDF$densities/sum(densitiesDF$densities) * 100, 2)
densitiesDF$percentage <- paste(densitiesDF$percentage, "%")


# Se hace un diagrama de barras con los porcentajes relativos.
ggplot(densitiesDF, aes(x = countries, y = densities, fill = reorder(countries, densities))) +
  geom_bar(stat = "identity", color = "black") + 
  labs(title = "Densidad de Trimeresurus en el Sudeste Asiático",
       subtitle = paste("Observaciones de GBIF; n =", length(spdata), ""),
       x = "Países", y = " ", fill = "País") + 
  theme_classic() + 
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        text = element_text(size = 11)) +
  scale_fill_brewer(palette = "greens") +
  geom_text(aes(label = percentage, vjust = -0.5, hjust = 0.3))
  
# El siguiente paso es mapear los datos de la densidad.
# Para ello se crea una grid con raster. 
rasterThailand <- raster(thailand)
# Se lleva la resolución a 0.3.
res(rasterThailand) <- 0.3
# Se rasteriza el polígono de Tailandia con la grid creada. 
rasterThailand <- rasterize(thailand, rasterThailand)
plot(rasterThailand)
# Se transforma el objeto ráster en un objeto espacial tipo polígono 
quadrat <- as(rasterThailand, "SpatialPolygons")
plot(quadrat, add = TRUE)
# Se añaden los puntos de identificación de los sujetos. 
points(spdata, col = "darkred", cex = 0.5)


# Salen todos los puntos.
# Nos interesa los que se encuentran dentro de la grilla, luego...
rasterspdataThailand <- rasterize(coordinates(spdata),
                            rasterThailand,
                            fun = "count", background = 0)

plot(rasterspdataThailand)
plot(thailand, add = TRUE)

# Se utiliza mask para enmascarar todos los puntos fuera de la grid.
maskpoints <- mask(rasterspdataThailand, rasterThailand)
plot(maskpoints)
plot(thailand, add = TRUE)
# Ahora sí que se tienen solamente los valores de la densidad para Tailandia.

# Estadísticos para hallar densidades cercanas y lejanas.
# Se unen todos las listas que recogen información de los países del sureste asiático.
SEAsia <- rbind(thailand, malasya, indonesia, 
                cambodia, vietnam, myanmar, laos, makeUniqueIDs = TRUE)
# Se transforman en objetos espaciales de la clase polígono. 
SEAsia <- as(SEAsia, "SpatialPolygons")
plot(SEAsia)


# Se crea un objeto con las coordenadas.
coordenadas <- SpatialPoints(spdata@coords, proj4string = CRS("+init=epsg:4326"))

# Con over se ven qué coordenadas se encuentran sobre el objeto espacial.
# Se eliminan todas aquellas posiciones que se salgan del sudeste asiático.
coordenadas <- coordenadas[!is.na(over(coordenadas, SEAsia)),]

# Se calculan las frecuencias. 
freqSEAsia <- freq(maskpoints, useNA = "no")
head(freqSEAsia)
plot(freqSEAsia, pch = 20)

# Se calcula la media de puntos por cuadrante.
# Número de cuadrantes.
quadrantSum <- sum(freqSEAsia[,2])
# Número de ocurrencias por cuadrante. 
occSum <- sum(freqSEAsia[,1]*freqSEAsia[,2])
# Se calcula la media de ocurrencias por cuadrante.
avgSEAsian <- round(occSum/quadrantSum, 4)
avgSEAsian

# Se obtiene la tabla de frecuencias.
tableSEAsia <- data.frame(freqSEAsia)
colnames(tableSEAsia) <- c("k", "x")
# Se calculan las desviaciones.
tableSEAsia$kavg <- tableSEAsia$k - avgSEAsian
tableSEAsia$kavg2 <- tableSEAsia$kavg^2
tableSEAsia$xkavg2 <- tableSEAsia$kavg2 * tableSEAsia$x
head(tableSEAsia)


# Se calcula la varianza observada.
sigmaSEAsia <- sum(tableSEAsia$xkavg2) / (sum(tableSEAsia$x)-1)
sigmaSEAsia

# Se halla la VRM (variance to Mean Ratio) de las densidades.
vrmSEAsia <- sigmaSEAsia / avgSEAsian
vrmSEAsia

# Se calcula la matriz de distancias.
distances <- dist(coordenadas@coords)
# Esto es un objeto de la clase dist.
class(distances)
# Se transforma en matriz. 
distmat <- as.matrix(distances)
distmat[1:5, 1:5]
# Los valores de la diagonal son ceros y no se incluyen en los análisis.
# Se tranhsforman en NA para que no afecten a los cálculos. 
diag(distmat) <- NA
distmat[1:5, 1:5]
# Se calcula el mínimo de las distancias para cada fila. 
distmin <- apply(distmat, 1, min, na.rm = TRUE)
head(distmin)
# Se calcula la distancia media de los vecinos más cercanos.
distmeanNN <- mean(distmin)
distmeanNN
# Por último, se identifican los puntos de densidad más cercanos.
distminpoint <- apply(distmat, 1, which.min)
# Se grafican los países del sudeste de Asia y se identifican estos puntos.
plot(SEAsia)
# Se grafican todos los puntos. 
points(coordenadas, cex = 0.5, col = "steelblue")
# Se revierte el orden los puntos para encontrar primero las distancias más lejanas.
orden <- rev(order(distmin))
# Se encuentran los 25 primeros puntos.
far25 <- orden[1:25]
# Se busca el valor de sus puntos.
vecinos <- distminpoint[far25]
# Se grafican los 25 puntos más lejanos en rojo.
points(coordenadas@coords[far25, ], col = "firebrick3", pch = 20)
# Se grafican los puntos que tienen muchos puntos cerca.
points(coordenadas[vecinos, ], col = "deeppink")

# Una alternativa para trazar estos puntos es con mapView.
# Se transforman las coordenadas en un objeto espacial.
lejanosp <- SpatialPoints(coordenadas@coords[far25, ], 
                       proj4string = CRS("+init=epsg:4326"))
cercanosp <- SpatialPoints(coordenadas[vecinos], 
                       proj4string = CRS("+init=epsg:4326"))
mapView(SEAsia) + 
  mapView(coordenadas, col.regions = "purple") +
  mapView(lejanosp, col.regions = "red") +
  mapView(cercanosp, col.regions = "green")
  

# l¡La última alternativa es ggplot2

ggplot() + geom_spatial_polygon(data = SEAsia,
                                aes(x = long, y = lat, group = group,
                                    fill = "dark green"), size = 0.5,
                                alpha = 0.4, linetype = 1, color = "black") +
  geom_point(data = as.data.frame(coordenadas),
             aes(x = coords.x1, y = coords.x2, color = "purple"),
             pch = 16, size = 1.3, alpha = 0.6) +
  geom_point(data = as.data.frame(cercanosp),
             aes(x = coords.x1, y = coords.x2, color = "green"),
             pch = 16, size = 1.3, alpha = 0.6) +
  geom_point(data = as.data.frame(lejanosp),
             aes(x = coords.x1, y = coords.x2, color = "red"),
             pch = 16, size = 1.3, alpha = 0.6) + 
  theme_bw() +
  # Editar manualmente para que se respeten los colores elegidos y sus etiquetas.
  scale_fill_manual(name = NULL, values = c("dark green" = "dark green"),
                    labels = c("Sudeste Asiático")) +
  scale_color_manual(name = NULL, values = c("purple" = "purple", "green" = "green",
                                             "red" = "red"),
                     labels = c("Todos", "Vecinos Cercanos", "Vecinos Lejanos")) +
  labs(title = "Distribución de Trimeresurus spp. en el Sudeste Asiático", 
       x = "Longitud", y = "Latitud") +
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_blank(),
        axis.text.y = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 0, r = 3, b = 0, l = 10)),
        axis.text.x = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 3, r = 0, b = 5, l = 0)),
        axis.title.y = element_text(face = 2),
        axis.title.x = element_text(face = 2),
        plot.title = element_text(hjust = 0.5),
        axis.ticks = element_line(colour = "black"),
        legend.position = "bottom")

# Una forma alternativa más rápida de estudiar los datos de densidad es la siguiente.
# Se va a hacer para Sri Lanka.
sriLanka <- raster::getData("GADM", country = "LKA", level = 1)
# Ahora se obtiene el subconjunto de los sujetos GBIF de Taiwán.
dataSriLanka <- subset(occTrimeresurus$data, country == "Sri Lanka")
dataSriLanka <- dataSriLanka %>% dplyr::select(species, decimalLongitude, decimalLatitude)
dataSriLanka <- na.omit(dataSriLanka)
colnames(dataSriLanka) <- c("species", "longitude", "latitude")
dataspSriLanka <- SpatialPoints(coords = cbind(dataSriLanka$longitude, dataSriLanka$latitude),
                                proj4string = CRS("+init=epsg:4326"))

dataspSriLanka$species <- dataSriLanka$species

# Se realiza la gráfica.
sriLankaPlotDensity <- ggplot() + 
  geom_polygon(data = sriLanka, aes(x = long, y = lat, group = group),
               size = 0.5, fill = "grey81", alpha = 0.7,
               linetype = 1, color = "black") +
  stat_density2d(data = data.frame(dataspSriLanka), aes(x = coords.x1, y = coords.x2,
                                                        fill = ..level.., alpha = ..level..),
                 size = 0.01, bins = 16, geom = "polygon") +
  scale_fill_gradient(low = "darkslategray4", high = "firebrick3") +
  scale_alpha(range = c(0.00, 0.25), guide = FALSE) +
  theme_light() +
  theme(legend.position = "none",
        text = element_text(size = 12),
        plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, face = "bold")) +
  labs(title = "Densidad poblacional de Trimeresurus spp. en Sri Lanka",
       subtitle = "Número de Sujetos = 25", x = "Longitud", y = "Latitud") +
  coord_cartesian(xlim = c(79.5, 82), ylim = c(5.9, 10))
  
sriLankaPlotDensity


# Hacer lo mismo con la región de Taipei. 
taipei <- raster::getData("GADM", country = "TWN", level = 1)
dataTaipei <- subset(occTrimeresurus$data, country == "Chinese Taipei")
dataTaipei <- dataTaipei %>% dplyr::select(species, decimalLongitude, decimalLatitude)
dataTaipei <- na.omit(dataTaipei)
colnames(dataTaipei) <- c("species", "longitude", "latitude")
dataspTaipei <- SpatialPoints(coords = cbind(dataTaipei$longitude, dataTaipei$latitude),
                                proj4string = CRS("+init=epsg:4326"))
dataspTaipei$species <- dataTaipei$species

# Se realiza la gráfica.
taipeiPlotDensity <- ggplot() + 
  geom_polygon(data = taipei, aes(x = long, y = lat, group = group),
               size = 0.5, fill = "grey81", alpha = 0.7,
               linetype = 1, color = "black") +
  stat_density2d(data = data.frame(dataspTaipei), aes(x = coords.x1, y = coords.x2,
                                                        fill = ..level.., alpha = ..level..),
                 size = 0.01, bins = 16, geom = "polygon") +
  scale_fill_gradient(low = "blue", high = "firebrick3") +
  scale_alpha(range = c(0.2, 0.9), guide = FALSE) +
  theme_light() +
  theme(legend.position = "none",
        text = element_text(size = 12),
        plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, face = "bold")) +
  labs(title = "Densidad poblacional de Trimeresurus spp. en Taipei",
       subtitle = "Número de Sujetos = 160", x = "Longitud", y = "Latitud") 

taipeiPlotDensity

# Graficar por especies.
table(dataTaipei$species)

taipeiPlotDensity +
  facet_wrap(~species) 

  

