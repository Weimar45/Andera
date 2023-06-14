# Se cargan los paquetes. 

library(move)
library(adehabitatHR)
library(caTools)
library(spatialEco)
library(reshape2)
library(tibble)
library(sp)
library(ggplot2)
library(dplyr)
library(lubridate)
library(mapview)
library(cowplot)
library(ggspatial)

# Mismo procedimiento que en el caso anterior. 
data("buffalo")
buffaloData <- buffalo[["traj"]][[1]] %>% dplyr::select(x, y, date)
buffaloData$datetime <- as.POSIXct(buffaloData$date, format = "%Y-%m-%d %hh:%mm:%ss")
buffaloData$date <-  as.Date(buffaloData$datetime)
# Proyección UTM.  
buffalospUTM <- SpatialPoints(cbind(buffaloData$x, buffaloData$y),
                              proj4string = CRS("+init=epsg:32632"))
# Se transforma en una proyección Latitud-Longitud.
buffalospLatLong <- spTransform(buffalospUTM,
                                CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))


# El primer paso es crear un MCP (minimum convex polygon) con la especie.
# Con ello se calacula el área que ocupa en kilómetros cuadrados. 
# Con percent = 100 exiges que abarque el cien por cien de los puntos.
# La unidad de entrada es en metros y la salida en kilómetros cuadrados. 
# Recordar utilizar la proyección UTM ya que se está trabajando en metros. 
buffaloMcp <- mcp(buffalospUTM, percent = 100, unin = "m", unout = "km2") 
buffaloMcp

# Se traza el mapa. 
mapView(buffaloMcp, col.regions = "darkseagreen1", map.types = "OpenStreetMap") +
  mapView(buffalospLatLong, alpha = 0.2, cex = 0.5)
# El problema de esto es que si se pretende ver una evolución temporal 
# esta forma de calcular el mcp y luego graficarla es una forma poco precisa. 
# El motivo es que un valor atípico alterará todo el área ya que por esta vía
# todos los puntos se incluyen en el cálculo del mcp. Es decir, es muy sensible
# a los valores atípicos o outlier. 

# También se puede extraer el valor del área con mcp.area.
buffaloMcpArea <- mcp.area(buffalospUTM, percent = 100, unin = "m", unout = "km2")
buffaloMcpArea

# Ahora se calculan los estimadores nucleares de densidad o kde (kernel density estimates)
# Son funciones que te indican cómo modelar los datos sobre el movimiento de forma suave.
# Es decir, buscan evitar el sobreajuste y el infraajuste. 

# Primero se crean los KDE con la función href de contornos isopletas al 95%, 90% y 50%.
# Primero se utiliza el método ad hoc para suavizar, href. 
?kernelUD 
Khref <- kernelUD(buffalospUTM, h = "href", grid = 800, extent = 2.2)
Khref50 <- getverticeshr(Khref, 50, unin = "m", unout = "km2")
Khref95 <- getverticeshr(Khref, 95, unin = "m", unout = "km2")
Khref99 <- getverticeshr(Khref, 99, unin = "m", unout = "km2")

# Se definen las áreas para cada uno de los contornos. 
kernelAreashref <- kernel.area(Khref, percent = c(50,95,99), 
                               unin = "m", unout = "km2")

# Se trazan en el mapa los tres isocontornos. 
mapView(Khref99, col.regions = "darkseagreen1", map.types = "OpenTopoMap") +
  mapView(Khref95, col.regions = "darkorange2") +
  mapView(Khref50, col.regions = "firebrick2") +
  mapView(buffalospLatLong, alpha = 0.2, cex = 0.5)
# El contorno del 99% incluye todos los valores. 
# El contorno del 95% incluye los valores típicos (typical homer range).
# El contorno del 50% abarca el núcleo o core (concetrated areas).
# Este último son ñas áreas importantes, las que visita el animal con más frecuencia.


# Se aplica los mismo pero para el algortimo de los mínimos cuadrados. 
klcsv <- kernelUD(buffalospUTM, h = "LSCV", grid = 800, extent = 2.2)
klcsv50 <- getverticeshr(klcsv, 50, unin = "m", unout = "km2")
klcsv95 <- getverticeshr(klcsv, 95, unin = "m", unout = "km2")
klcsv99 <- getverticeshr(klcsv, 99, unin = "m", unout = "km2")
# Se calculan las áreas. 
kernelAreaslcsv <- kernel.area(klcsv, percent = c(50,95,99), 
                                unin = "m", unout = "km2")

# Hay ocaciones en las que este modelo no converge. No encuentra el mínimo
# para que el modelo converja.No se recomienda utilizar ete método si eso sucede. 
mapView(klcsv99, col.regions = "darkslateblue", map.types = "OpenTopoMap") +
  mapView(klcsv95, col.regions = "gold2") +
  mapView(klcsv50, col.regions = "firebrick3") +
  mapView(buffalospLatLong, alpha = 0.2, cex = 0.5)

# Finalmente se introduce manualmente como núcleo un factor de suavidad de 100. 
# Esto funciona por ensayo y error y genera errores de tipo I y II muy altos. 
Kh100 <- kernelUD(buffalospUTM, h = 100, grid = 800, extent =2.2)
Kh10050 <- getverticeshr(Kh100, 50, unin = "m", unout = "km2")
Kh10095 <- getverticeshr(Kh100, 95, unin = "m", unout = "km2")
Kh10099 <- getverticeshr(Kh100, 99, unin = "m", unout = "km2")

# Cálculo de las áreas. 
kernelAreash100 <- kernel.area(Kh100, percent = c(50,95,99), 
                                unin = "m", unout = "km2")

# Se grafica el modelo. 
mapView(klcsv99, col.regions = "aquamarine4", map.types = "OpenTopoMap") +
  mapView(klcsv95, col.regions = "cadetblue3") +
  mapView(klcsv50, col.regions = "aquamarine3") +
  mapView(buffalospLatLong, alpha = 0.2, cex = 0.5)


# Ahora se van a realizar los modelos dinámicos de Brownian Bridge, que 
# son los modelos matemáticos más precisos para definir el movimiento de
# animales. Estos modelos incorporan datos espaciales y temporales y crean
# rutas de movimiento y estimaciones UD basadas en esas rutas a tiempo, 
# mientras que KDE solo amplía la probabilidades de uso en función de puntos
# independientes sin que se haya contabilizado la autocorrelación temporal.
buffaloData$ID <- "buffalo"

# Otra ventaja de estos modelos es que se pueden incorporar errores de ubicación. 
# Esto es útil porque las señales GPS de los chips que se usan en animales 
# pueden traer errores. 
setLocError <- 5

# En caso de que hubiera, se eliminan las fechas que se han duplicado. 
buffaloData$datetime <- unique(buffaloData$datetime, .keep_all= FALSE)


# Se convierten los datos en objeto move para el cáculo de los 
# modelos de Brownian Bridge usando el objeto UTM. 
moveObject <- move(x = buffaloData$x, y = buffaloData$y, 
                   proj = CRS("+init=epsg:32632"),
                   time = as.POSIXct(buffaloData$datetime))

# Se mira el objeto de movimiento creado. 
moveObject

# Se establece el tamaño de la ventana y de los márgenes.
# Es específico para el conjunto de datos de tu conjunto de animales. 
# Esto significa que como mínimo se evalúan 13 medidas y cinco de ellas
# habrán de tener un comportamiento cambiante (de resting state a transit state). 
windowSize <- 13
marginSize <- 5

# Se establece la cuadrícula en la que se calculará la distribución 
# de utilización de forma similar a lo que se tenía que hacer en la 
# función kernelUD.
setGridExt <- 2.2
setDimSize <- 800

# Se calcula el modelo de Brownian Bridge. 
brownianBridgeModel <- brownian.bridge.dyn(object = moveObject,
                                           location.error = setLocError,
                                           margin = marginSize,
                                           window.size = windowSize,  
                                           ext = setGridExt, 
                                           dimSize = setDimSize,  
                                           verbose = F) 

# El modelo BB se crea como un raster, por lo que se precisa de su transformación
# en un objeto UD (utilization density) para trazar los contornos isopletas en los mapas. 
# class(brownianBridgeModel)
browiansp <- as(brownianBridgeModel, "SpatialPixelsDataFrame")
# class(browiansp)
browianspud <- new("estUD", browiansp)
# Sin volumen: 
browianspud@vol = FALSE 
# El método es dBBMM. 
browianspud@h$meth = "dBBMM"
browianud <- getvolumeUD(browianspud, standardize = TRUE) 
# Ahora se tiene la distribución de utilización de la población de búfalos. 

# Se puede comparar con la salida de los otros modelos. 
plot(Khref)
plot(klcsv)
plot(Kh100)
plot(browianud)

# Ahora se pueden extraer los contornos de isopletas. 
browian50 <- getverticeshr(browianud, percent = 50, unin = "m", unout = "km2")
browian95 <- getverticeshr(browianud, percent = 95, unin = "m", unout = "km2")
browian99 <- getverticeshr(browianud, percent = 99, unin = "m", unout = "km2")


# Finalmente se crea un objeto de valor de la zona de rango de inicio. 
browianAreas <- kernel.area(browianud, percent = c(50,95,99), 
                            unin = "m", unout = "km2")

# Now we can map the ispopleths to see what the dBBMM created
mapview(browian99, col.regions = "darkorchid4", map.type = "OpenTopoMap") +
  mapview(browian95, col.regions = "firebrick2") + 
  mapview(browian50, col.regions = "azure2") +
  mapview(buffalospUTM, alpha = 0.1, cex = 0.5)

# Como se puede ver, el modelo de Browian muestra mucha más conectividad
# y menos áreas irregulares que los isopleths KDE.


# ~~~~~~~~~~~~~~~~~~~~~ Validación del Modelo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Una de las métricas más utilizadas para la bondad relativa de los
# estimadores de distribución de utilización es el Área bajo curva (AUC),
# al igual que la validación utilizada para el modelado de distribución 
# de especies. Otra técnica importante utilizada para examinar los contornos
# de isopletas UD es la complejidad de los polígonos. Normalmente, el mejor
# modelo no solo tendrá el valor de AUC más alto, sino que también tendrá
# una compensación entre errores de tipo I (sobreesmoothing - UD que 
# representa áreas que no están ocupadas) y errores de tipo II (subsmoothing
# - UD carente de áreas que pueden ser ocupadas), representados por la 
# complejidad de los contornos isopleta. 

# Primero se hará una tabla de la AUC. Se realiza esto haciendo
# un ráster de nuestras ubicaciones sobre nuestro objeto distribución de 
# utilización. A continuación, se extraen los valores reales frente a null
# del marco de datos, y con eso se calcula el AUC utilizando métodos wilcoxon 
# y la ROC. Sin embargo, se eliminará el valor KLSCV de este análisis,
# ya que no pudo converger y, por lo tanto, es un valor NULL. Además, dado 
# que mcp es sólo un representante generalizado del home range y no
# un estimador ud, también será omitido de estos análisis.

# Se transforma el modelo en un ráster. 
nLocationRaster <- count.points(buffalospUTM, browianud) 
# Se extrae el vector que contiene los valores predichos del volumen del contorno. 
kernelData <- browianud@data$n 
pointData <- nLocationRaster@data$x 
# Se define el vector con los valores de hecho de la localización.
pointData <- ifelse(pointData >= 1, 1, 0)
# Se calcula el AUC. 
browianAUC<-colAUC(kernelData, pointData,
                 plotROC = FALSE, 
                 alg = c("Wilcoxon","ROC"))

############## AQUI TE HAS QUEDADO
# Se hace lo mismo para khref. 
Khrefud <- getvolumeUD(Khref, standardize=FALSE)
nlocrast<-count.points(buffalospUTM, Khrefud) 
kernelData <- Khrefud@data$n 
pointData <- nlocrast@data$x 
pointData <- ifelse(pointdata>=1,1,0) 
KhrefAUC <- colAUC(kernelData, pointData,
                   plotROC = FALSE,
                   alg = c("Wilcoxon","ROC"))

# En el caso de KLSCV.
AUCKLSCV <- NA

#########this is for Kh100 (remember we used UTM for this estimator)
Kh100ud <- getvolumeUD(Kh100, standardize=FALSE)
nlocrast<-count.points(sp.UTM,Kh100ud) 
kerneldata <- Kh100ud@data$n # vector containing volume contour (= predicted) values
pointdata <- nlocrast@data$x 
pointdata <- ifelse(pointdata>=1,1,0) # vector containing location (= actual) values 
AUCKh100 <- colAUC(kerneldata, pointdata, plotROC=FALSE, alg=c("Wilcoxon","ROC"))


# Now we will create a data frame with our data
AUCdf <- cbind(AUCKhref[1], AUCKLSCV[1], AUCKh100[1],
               AUCdBBMM[1])
# convert it to a dataframe so it can have columns and row names
AUCdf <- as.data.frame(AUCdf)
# name the columns with the corresponding estimation method
names(AUCdf) <- c("Khref","KLSCV","Kh100","dBBMM")
# print and view the AUC table
print(AUCdf)

# As we can see from our AUC evaluation the Kh100 appears to be 
# the best fit model, with dBBMM in second and the Khref last (which is
# usually the case... basically, don't use khref). However, to make sure
# we choose the best-of-fit model we should also take into consideration
# the complexity and liklihood of type I and type II errors at each
# isopleth contour. To do this, we need to divide the perimeter of each 
# polygon by its total area (complexity = perimeter/total area)

# first, we will get the perimeter of each isopleth contour using the 
# polyPerimeter() function from the spatialEco package


#dbbmm perimeter
pdbbmm99 <- as(dBBMM.099, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pdbbmm95 <- as(dBBMM.095, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pdbbmm50 <- as(dBBMM.050, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000

#KDEhref perimeter
pKhref99<-as(Khref99, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pKhref95<-as(Khref95, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pKhref50<-as(Khref50, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000

#KDELSCV perimeter
pKLSCV99<-as(KLSCV99, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pKLSCV95<-as(KLSCV95, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pKLSCV50<-as(KLSCV50, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000

#Kh100 perimeter
pKh10099<-as(Kh10099, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pKh10095<-as(Kh10095, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000
pKh10050<-as(Kh10050, "sf") %>% sf::st_cast("MULTILINESTRING") %>% sf::st_length()/1000



#-------------------------------------

# Now we will get the information for the total area of each polygon 

#dbbmm area 
adbbmm99<-dBBMM.areas[3]
adbbmm95<-dBBMM.areas[2]
adbbmm50<-dBBMM.areas[1]

#KDEhref area
aKhref99<-kernelareashref[3]
aKhref95<-kernelareashref[2]
aKhref50<-kernelareashref[1]

#KDELSCV area
aKLSCV99<-kernel.areasLSCV[3]
aKLSCV95<-kernel.areasLSCV[2]
aKLSCV50<-kernel.areasLSCV[1]

#Kh100 area
aKh10099<-kernel.areash100[3]
aKh10095<-kernel.areash100[2]
aKh10050<-kernel.areash100[1]

#---------------------------------------------
# Now we calculate the complexity
# Complexity = perimeter(m) / total area (km)

#dbbmm complexity
cdbbmm99<-pdbbmm99 / adbbmm99
cdbbmm95<-pdbbmm95 / adbbmm95
cdbbmm50<-pdbbmm50 / adbbmm50

#KDEhref complexity
cKhref99<-pKhref99 / aKhref99
cKhref95<-pKhref95 / aKhref95
cKhref50<-pKhref50 / aKhref50

#KDELSCV complexity
cKLSCV99<-pKLSCV99 / aKLSCV99
cKLSCV95<-pKLSCV95 / aKLSCV95
cKLSCV50<-pKLSCV50 / aKLSCV50

#Kh100 complexity
cKh10099<-pKh10099 / aKh10099
cKh10095<-pKh10095 / aKh10095
cKh10050<-pKh10050 / aKh10050


# Save the complexity values as a data frame
Complexity <- cbind(cdbbmm99,cdbbmm95,cdbbmm50,
                    cKhref99,cKhref95,cKhref50,
                    cKLSCV99,cKLSCV95,cKLSCV50,
                    cKh10099,cKh10095,cKh10050)
# convert it to a dataframe so it can have columns and row names
Complexity <- as.data.frame(Complexity)
# name the columns with the corresponding estimation method
names(Complexity) <- c("dbbmm99","dbbmm95","dbbmm50",
                       "Khref99","Khref95","Khref50",
                       "KLSCV99","KLSCV95","KLSCV50",
                       "Kh10099","Kh10095","Kh10050")
# rename rows for the sake of neatness
row.names(Complexity) <- "Complexity"

Complexity

# now lets create a more meaningful data frame to review our data
# from both analyses
model.analysis <- data.frame(1:4)
model.analysis$Method <- c("Khref", "KLSCV", "Kh100", "dBBMM")
model.analysis$AUC <- c(AUCdf[1,])
model.analysis$comp_99 <- c(Complexity$Khref99, Complexity$KLSCV99,
                            Complexity$Kh10099, Complexity$dbbmm99) 
model.analysis$comp_95 <- c(Complexity$Khref95, Complexity$KLSCV95,
                            Complexity$Kh10095, Complexity$dbbmm95) 
model.analysis$comp_50 <- c(Complexity$Khref50, Complexity$KLSCV50,
                            Complexity$Kh10050, Complexity$dbbmm50) 


# To properly examine our analysis, we have to understand that large 
# complexity values indicate oversmoothing, while smaller values may
# indicate undersmoothing. First we will run code to disable scientific 
# notation so we can see the values more clearly
options(scipen=999)
print(model.analysis)

# Now we can save our model analysis as a .csv file
# first we need to switch AUC to a numeric value
model.analysis$AUC <- as.numeric(model.analysis$AUC)
model.analysis
write.csv(model.analysis, "model_analysis.csv")

# We can see from our values that Khref has large complexity 
# and is likely to be oversmoothing all isopleth contours, we can visualize
# this oversmoothing by plotting our MCP and 99% khref polygon
# and see that it massively breaches the maximum 100% extent of our points
mapview(MCP, col.regions = "red") + mapview(Khref99)

# we can better visualize the trends by making a ggplot graph
# we first need to "melt()" the dataframe to condense the data
melt.analysis <- melt(model.analysis, id = c("Method", "AUC"))
#remove the first 4 rows
melt.analysis <- melt.analysis[-c(1,2,3,4),]

# now plot the figure
analysis.plot <- ggplot(melt.analysis, aes(x = variable, y = value)) +
  geom_line(aes(color = Method, group = Method), size=0.8)+
  theme_minimal()+
  theme(panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
        element_blank(),
        legend.position = "bottom", 
        plot.title = element_text(hjust = 0.5, size = 10, face = "bold.italic"),
        axis.text=element_text(size=10),
        axis.title=element_text(size=10,face="bold"))+
  xlab("Countour (%)") + ylab("Complexity")+
  labs(title = "Model Complexity at 50%, 95%, & 99%", size = 10)+
  scale_x_discrete(labels=c("99%", "95%", "50%"))

analysis.plot

# We can also see that the dBBMM model has a slightly higher complexity 
# for the 99% isopleth than kLSCV and Kh100, this is likely because the 
# model creates a temporal path with the polygons and should not necessarily
# be considered as overfitting the data.

# dBBMM appears to be the tradeoff between the models other than the heightened
# value at 99%, as its values fall between both KLSCV and Kh100 for the lower
# isopleth contours.


# ~~~~~~~~~~~~~~~~~~~~~ Figures ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ggplot is weird with UTM spatial objects sometimes, so we will transform
# all of our spatialpolygons to latlong first
MCP <- spTransform(MCP,
                   CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
#-------------------------------
Khref99 <- spTransform(Khref99,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
Khref95 <- spTransform(Khref95,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
Khref50 <- spTransform(Khref50,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
#-----------------------------
KLSCV99 <- spTransform(KLSCV99,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
KLSCV95 <- spTransform(KLSCV95,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
KLSCV50 <- spTransform(KLSCV50,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
#------------------------------
Kh10099 <- spTransform(Kh10099,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
Kh10095 <- spTransform(Kh10095,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
Kh10050 <- spTransform(Kh10050,
                       CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
#------------------------------
dBBMM.099 <- spTransform(dBBMM.099,
                         CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
dBBMM.095 <- spTransform(dBBMM.095,
                         CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))
dBBMM.050 <- spTransform(dBBMM.050,
                         CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"))



#dBBMM
dBBMM.plot <- ggplot() +
  geom_spatial_polygon(data = MCP, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black", fill = NA) +
  geom_spatial_polygon(data = dBBMM.050, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 1, color = "black", fill="black") +
  geom_spatial_polygon(data = dBBMM.095, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black", fill="black") +
  geom_spatial_polygon(data = dBBMM.099, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 3, color = "black", fill="black") +
  geom_point(data = as.data.frame(sp.latlong),
             aes(x = coords.x1, y = coords.x2),
             colour = "black", pch = 16, size = 0.5, alpha=0.2) + 
  theme_bw() +
  labs(x = "Longitude", y = "Latitude", title = "dBBMM")+
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_blank(),
        axis.text.y = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 0, r = 3, b = 0, l = 10)),
        axis.text.x = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 3, r = 0, b = 5, l = 0)),
        axis.title.y = element_text(face = 2),
        axis.title.x = element_text(face = 2),
        axis.ticks = element_line(colour = "black"))
dBBMM.plot

#-----------------------------------------------------

#Khref
Khref.plot <- ggplot() +
  geom_spatial_polygon(data = MCP, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black", fill = NA) +
  geom_spatial_polygon(data = Khref99, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 1, color = "black") +
  geom_spatial_polygon(data = Khref95, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black") +
  geom_spatial_polygon(data = Khref50, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 3, color = "black") +
  geom_point(data = as.data.frame(sp.latlong),
             aes(x = coords.x1, y = coords.x2),
             colour = "black", pch = 16, size = 0.5, alpha=0.2) + 
  theme_bw() +
  labs(x = "Longitude", y = "Latitude",title = "Khref")+
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_blank(),
        axis.text.y = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 0, r = 3, b = 0, l = 10)),
        axis.text.x = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 3, r = 0, b = 5, l = 0)),
        axis.title.y = element_text(face = 2),
        axis.title.x = element_text(face = 2),
        axis.ticks = element_line(colour = "black"))
Khref.plot 


#--------------------------------------------------------------

#KLSCV
KLSCV.plot <- ggplot() +
  geom_spatial_polygon(data = MCP, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black", fill = NA) +
  geom_spatial_polygon(data = KLSCV99, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 1, color = "black") +
  geom_spatial_polygon(data = KLSCV95, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black") +
  geom_spatial_polygon(data = KLSCV50, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 3, color = "black") +
  geom_point(data = as.data.frame(sp.latlong),
             aes(x = coords.x1, y = coords.x2),
             colour = "black", pch = 16, size = 0.5, alpha=0.2) + 
  theme_bw() +
  labs(x = "Longitude", y = "Latitude",title = "KLSCV")+
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_blank(),
        axis.text.y = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 0, r = 3, b = 0, l = 10)),
        axis.text.x = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 3, r = 0, b = 5, l = 0)),
        axis.title.y = element_text(face = 2),
        axis.title.x = element_text(face = 2),
        axis.ticks = element_line(colour = "black"))
KLSCV.plot 

#--------------------------------------------------------------
#KLSCV
Kh100.plot <- ggplot() +
  geom_spatial_polygon(data = MCP, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black", fill = NA) +
  geom_spatial_polygon(data = Kh10099, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 1, color = "black") +
  geom_spatial_polygon(data = Kh10095, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 2, color = "black") +
  geom_spatial_polygon(data = Kh10050, aes(x = long, y = lat, group = group), size = 0.5,
                       alpha = 0.2, linetype = 3, color = "black") +
  geom_point(data = as.data.frame(sp.latlong),
             aes(x = coords.x1, y = coords.x2),
             colour = "black", pch = 16, size = 0.5, alpha=0.2) + 
  theme_bw() +
  labs(x = "Longitude", y = "Latitude",title = "Kh100")+
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_blank(),
        axis.text.y = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 0, r = 3, b = 0, l = 10)),
        axis.text.x = element_text(face = 2, size = 9, colour = "black",
                                   margin = margin(t = 3, r = 0, b = 5, l = 0)),
        axis.title.y = element_text(face = 2),
        axis.title.x = element_text(face = 2),
        axis.ticks = element_line(colour = "black"))
Kh100.plot 

#-------------------------------------------
#group all plots together in a 2x2 grid
pg <- plot_grid(Khref.plot, KLSCV.plot, Kh100.plot, dBBMM.plot,
                nrow = 2, ncol = 2)
pg


# Now plot all all figures with the complexity figure
pg.1 <- plot_grid(pg, analysis.plot, nrow = 1, ncol = 2)
pg.1

model.analysis
#~~~~~~~~~~~~~~~~ HOME RANGE VALUES ~~~~~~~~~~~~~~~~~~~~~~~

# In order to visualize the variations in home range values,
# we will plot them using a barchart in ggplot

# first we will need to create and melt a data frame with the 
homeranges <- as.data.frame(cbind(dBBMM.areas, kernelareashref,
                                  kernel.areasLSCV, kernel.areash100))
homeranges <- tibble::rownames_to_column(homeranges, "VALUE")

# melt for plotting
homeranges.melt <- melt(homeranges, id = "VALUE")

#plot the data
p3 <- ggplot(homeranges.melt, aes(x=variable, y=value, fill=VALUE)) +
  geom_bar(stat="identity", position = "dodge", col = "black") +
  theme_classic()+
  theme(panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
        element_blank(),
        legend.position = "bottom", 
        plot.title = element_text(hjust = 0.5, size = 10, face = "bold.italic"),
        axis.text=element_text(size=10),
        axis.title=element_text(size=10,face="bold"))+
  xlab("Model") + ylab("Home Range")+
  labs(title = "Home Range size at 50%, 95%, & 99% (km^2)", size = 10,
       subtitle = "")+
  scale_x_discrete(labels=c("dBBMM", "Khref", "KLSCV", "Kh100"))

p3

# Se combinan los gráficos. 
# Se co,binan el análisis y el HR (Home Ranges)
pg2 <- plot_grid(analysis.plot, p3, nrow = 2, ncol = 1) 
# Combinación de todos los gráficos.
pg3 <- plot_grid(pg, pg2, nrow = 1, ncol = 2) 


