# Se cargan los paquetes necesarios. 

library(raster)
library(mapview)
library(ggplot2)
library(dplyr)
library(rgbif)
library(maptools)
library(scrubr)


# Obtener los dadtos de GBIF. Se han elegido 
# Panthera onca: El jaguar, yaguar o yaguareté. 
# Alouatta pigra: mono aullador negro guatemalteco.
species <- name_suggest(q = "Panthera onca", rank = "species")
occPantheraOnca <- occ_search(taxonKey = species$data$key)
occPantheraOnca$meta$count
dataPantheraOnca <- occPantheraOnca$data
table(dataPantheraOnca$country)
brazilPantheraOnca <- dataPantheraOnca %>% filter(country == "Brazil") %>% dplyr::select(species, decimalLongitude, decimalLatitude)
colnames(brazilPantheraOnca) <- c("species", "longitude", "latitude")
brazilPantheraOnca <- na.omit(brazilPantheraOnca)
# Limpiar las coordenadas. 
brazilspPantheraOnca <- brazilPantheraOnca %>% coord_impossible() %>% coord_unlikely()
# Crear el objeto espacial. 
brazilsp <- SpatialPoints(cbind(brazilspPantheraOnca$longitude,
                                brazilspPantheraOnca$latitude), 
                          proj4string = CRS("+init=epsg:4326"))


species <- name_suggest(q = "Alouatta pigra", rank = "species")
occAlouattaPigra <- occ_search(taxonKey = species$data$key)
occAlouattaPigra$meta$count
dataAlouattaPigra <- occAlouattaPigra$data
table(dataAlouattaPigra$country)
belizeAlouattaPigra <- dataAlouattaPigra %>% filter(country == "Belize") %>% dplyr::select(species, decimalLongitude, decimalLatitude)
colnames(belizeAlouattaPigra) <- c("species", "longitude", "latitude")
# Limpiar las coordenadas. 
belizespAlouattaPigra <- belizeAlouattaPigra %>% coord_impossible() %>% coord_unlikely()
# Crear el objeto espacial. 
belizesp <- SpatialPoints(cbind(belizespAlouattaPigra$longitude,
                                belizespAlouattaPigra$latitude), 
                          proj4string = CRS("+init=epsg:4326"))


# Hacer los mapas.
mapView(brazilsp, map.types = "OpenTopoMap")
mapView(belizesp, map.types = "OpenTopoMap")

# Latitud y longitud medias de ambas especies. 
brazilLonAvg <- mean(brazilsp@coords[,1])
brazilLatAvg <- mean(brazilsp@coords[,2])
belizeLonAvg <- mean(belizesp@coords[,1])
belizeLatAvg <- mean(belizesp@coords[,2])

# Tomar los mapas de Belize y de Brasil de GADM.
# Si falla getData ir a https://gadm.org/download_country_v3.html
# La web se cae a menudo, así que puede que hayas de esperar un par de días.
brazil <- getData("GADM", country = "BRA", level = 0)
belize <- getData("GADM", country = "BLZ", level = 0)


# Se toman las coordenadas centrales del polígono o mapa.
mlongBrazil <- (brazil@bbox[1] + brazil@bbox[3])/2
mlatBrazil <- (brazil@bbox[2] + brazil@bbox[4])/2

mlongBelize <- (belize@bbox[1] + belize@bbox[3])/2
mlatBelize <- (belize@bbox[2] + belize@bbox[4])/2


# Se casan las proyecciones con los datos espaciales de nuestras especies.
proj4string(brazil) <- projection(brazilsp)
proj4string(belize) <- projection(belizesp)

# Tomar los sujetos de la especie que caen dentro del país.
# Esto es debido a que puede haber un mal etiquetado y caer en zonas
# cercanas, como en islas o países circundantes. 
brazilsp <- 
belizesp 












































