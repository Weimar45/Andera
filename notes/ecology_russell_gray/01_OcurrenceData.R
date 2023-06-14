install.packages(c("rgbif", "mapview", "scrubr", "sp"))

library(rgbif) # Obtener acceso de bases de datos de ecología. 
library(mapview) # Alternativa a plot para datos espaciales.
library(scrubr) # Para tratar valores atípicos en datos espaciales (los polos Ártico y Antártico)
library(sp) # Toma datos espaciales y crea un objeto específico para su manejo.
library(dplyr)


?occ_search

# Se aplica la función para el estudio de pitones. 
fam <- name_suggest(q = "Pythonidae", rank = "family")

# Mostrar el número total de sujetos de la base de datos Pythonidae.
# Se ha depreciado el parámetro return para facilitar el mantenimiento 
# metadata <- occ_search(taxonKey = fam$data$key, return = "meta")
# https://cran.r-project.org/web/packages/rgbif/news/news.html
pythonidaeObject <- occ_search(taxonKey = fam$data$key)
pythonidaeObject$meta$count

# solamente de especies nativas. 
pythonidaeObjectNative <- occ_search(taxonKey = fam$data$key,
                                     establishmentMeans = "NATIVE")
pythonidaeObjectNative$meta$count

# Extraer el marco de datos. 
pythonidaeData <- pythonidaeObject$data
pythonidaeDataNative <- pythonidaeObjectNative$data
  
pythonidaeData <- pythonidaeData %>% select(species, decimalLatitude, decimalLongitude)
colnames(pythonidaeData) <- c("species","lat","lon")

pythonidaeDataNative <- pythonidaeDataNative %>% select(species, decimalLatitude, decimalLongitude)
colnames(pythonidaeDataNative) <- c("species","lat","lon")

# Eliminar valores perdidos.
pythonidaeData <- na.omit(pythonidaeData)
pythonidaeDataNative <- na.omit(pythonidaeDataNative)

# Conocer el sistema de coordenadas para localizar los datos de longitud y de latitud.
table(pythonidaeObject$data$geodeticDatum)

# Ver el número de especies. 
table(pythonidaeData$species)
table(pythonidaeDataNative$species)

# Limpieza con el paquete scrubr. Eliminar coordenadas imposibles e improbables.
pythonidaeData <- dframe(pythonidaeData) %>% coord_impossible()
pythonidaeData <- dframe(pythonidaeData) %>% coord_unlikely()

pythonidaeDataNative <- dframe(pythonidaeDataNative) %>% coord_impossible()
pythonidaeDataNative <- dframe(pythonidaeDataNative) %>% coord_unlikely()

xtable::xtable(pythonidaeData)

# Creación del objeto espacial. Primero se pone longitud (x) y después latitud (y).
pythonSP <- SpatialPoints(coords = cbind(pythonidaeData$lon, pythonidaeData$lat),
                          proj4string = CRS("+init=epsg:4326"))
pyhtonSPNative <- SpatialPoints(coords = cbind(pythonidaeDataNative$lon, pythonidaeDataNative$lat),
                                proj4string = CRS("+init=epsg:4326"))
# Para lo de CRS: 4326 es solo el identificador EPSG de WGS84. 
# Si realmente va a elegir un nit: EPSG 4326 define un sistema de referencia
# de coordenadas completo, proporcionando significado espacial a pares de
# números que de otro modo no tendrían sentido. Significa "coordenadas de
# latitud y longitud en el elipsoide de referencia WGS84".
pythonSP
pyhtonSPNative

# Se añade el nombre de las especies al objeto espacial. 
pythonSP$species <- pythonidaeData$species
pyhtonSPNative$species <- pythonidaeDataNative$species

# Se contempla el objeto. 
mapView(x = list(pythonSP, pyhtonSPNative))

# Cambiar color y opacidad. 
mapView(x = list(pythonSP, pyhtonSPNative),
        alpha.regions = 0.7,
        col.regions = mapviewGetOption("raster.palette"))


# Volver a trabajar con el marco inicial.
pythonidaeDataNative <- pythonidaeObjectNative$data

# Mirar en qué países hay especies nativas. 
table(pythonidaeDataNative$country)

# No deberían estar los de EEUU porque no tiene especies nativas de pitón,
# luego se hace un subconjunto que las excluya.
pythonidaeDataNative <- subset(pythonidaeDataNative, 
                               country !="United States of America")
table(pythonidaeDataNative$country)

# Se repite el proceso anterior. 
pythonidaeDataNative <- pythonidaeDataNative %>% select(species, decimalLatitude, decimalLongitude)
colnames(pythonidaeDataNative) <- c("species","lat","lon")
pythonidaeDataNative <- na.omit(pythonidaeDataNative)
pythonidaeDataNative <- dframe(pythonidaeDataNative) %>% coord_impossible()
pythonidaeDataNative <- dframe(pythonidaeDataNative) %>% coord_unlikely()
pyhtonSPNative <- SpatialPoints(coords = cbind(pythonidaeDataNative$lon, pythonidaeDataNative$lat),
                                proj4string = CRS("+init=epsg:4326"))
pyhtonSPNative$species <- pythonidaeDataNative$species
mapView(x = pyhtonSPNative)
