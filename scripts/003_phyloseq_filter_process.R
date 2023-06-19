# Carga de la librería.
library(pacman)

p_load(phyloseq, vegan, ggplot2)

# Cargar un objecto phyloseq.
data("GlobalPatterns")

# Inicio del Filtrado

# Filtrar por abundancia total: el objetivo en este caso es eliminar las OTUs que tienen
# una abundancia total por debajo de un cierto umbral. Esto puede ser útil para eliminar
# las OTUs raras o los posibles artefactos de secuenciación, que podrían añadir ruido a
# los análisis.

# La función filter_taxa() en el paquete phyloseq de R se utiliza para filtrar 
# las OTUs (Unidades Taxonómicas Operativas) en un objeto phyloseq. El valor de
# X en la función function(x) sum(x) > X determina el umbral de abundancia que 
# una OTU debe tener para ser conservada en el conjunto de datos.

# No existe un estándar único para el valor de X ya que este puede variar 
# dependiendo del estudio y del conjunto de datos. Sin embargo, un enfoque 
# común es eliminar las OTUs que están presentes en menos de un cierto número
# de muestras. Por ejemplo, si tienes 100 muestras, podrías establecer X en 10
# para eliminar las OTUs que están presentes en menos de 10 muestras. 
# Esto ayudaría a eliminar las OTUs que son raras o que podrían ser artefactos
# de secuenciación.

# Es importante tener en cuenta que el filtrado de OTUs es una decisión que debe
# basarse en el conocimiento del conjunto de datos y del objetivo del análisis. 
# Es posible experimentar con diferentes valores de X para ver cómo
# afectan a tus resultados.

# En este caso tenemos 26 muestras, como vimos en el script anterior, por lo que
# podríamos establecer una abundancia total de 5 como umbral para las OTUs.
physeq_filtered <- filter_taxa(GlobalPatterns, function(x) sum(x) >= 5, TRUE)

# Otra vía para hacer esto sería utilizar la función prune_taxa
prune_taxa(taxa_sums(GlobalPatterns) >= 5, GlobalPatterns)

# Filtrado independiente por presencia en un número mínimo de muestras: 
# se quitan aquellas OTU que no aparezcan en más de X muestras. 

# La opción para eliminar estas OTUs muy raras es también prune_taxa. Esta función de phyloseq
# se utiliza para subconjuntar o "podar" un objeto phyloseq a un conjunto específico
# de taxones (OTUs), y es útil cuando sólo se está interesado en un subconjunto 
# específico de taxones y se quiere eliminar el resto del objeto phyloseq.
# Por ejemplo, podemos eliminar aquellas OTUs que están presentes en al menos 3 muestras
# sobre el objeto phyloseq ya filtrado previamente por la abundancia total de la siguiente forma: 
physeq_filtered <- prune_taxa(rowSums(otu_table(physeq_filtered) > 0) >= 3, physeq_filtered)

# Filtrado por taxonomía: Si se está interesado en un grupo taxonómico específico, 
# se podría usar tabién prune_taxa() junto con subset_taxa(). Por ejemplo, 
# se subconjuntaría el objeto GlobalPatterns a sólo las OTUs del filo Firmicutes así: 
prune_taxa(taxa_names(subset_taxa(GlobalPatterns, Phylum == "Firmicutes")), GlobalPatterns)

# Esto también se puede hacer para eliminar la especie que se haya usado de testigo 
# en el experimento y para eliminar las OTUs de cloroplastos y mitocondrias, que 
# pueden ser devueltas por contaminaciones en los procesos de secuenciación. 
physeq_filtered <- subset_taxa(physeq_filtered, !(Class %in% "c:Chloroplast"))
physeq_filtered <- subset_taxa(physeq_filtered, !(Family %in% "f:Mitochondria"))

# Filtrado por variabilidad: ste tipo de filtrado implica eliminar las OTUs que tienen
# una variabilidad baja o alta en su abundancia entre las muestras. Este tipo de filtrado
# puede ser relevante para eliminar las OTUs que son constantes o muy variables entre
# las muestras, ya que podrían no ser informativas para los análisis posteriores.

# El filtrado por variabilidad en phyloseq se puede hacer mediante la función filter_taxa(),
# que permite aplicar una función personalizada a las abundancias de cada OTU.
# Para filtrar por variabilidad, puedes definir una función que calcule una medida
# de variabilidad, como la desviación estándar o el coeficiente de variación, 
# y luego aplicar esta función a las abundancias de cada OTU.
# Este método de filtrado asume que las abundancias de las OTUs están en la misma escala.
# Por ende, si los datos están en formato de conteo de lecturas de secuenciación, 
# es preciso normalizarlos antes de realizar el filtrado por variabilidad. 
# Una opción común para la normalización es la normalización por tamaño de muestra,
# la cual se puede realizar en phyloseq utilizando la función transform_sample_counts().
# Una opción común para la normalización es dividir las cuentas de cada muestra por el
# tamaño de la muestra, lo que se conoce como normalización por tamaño de muestra.

# Ver el objeto phyloseq antes del filtrado.
physeq_filtered

# Número de OTUs antes del filtrado
ntaxa_before <- ntaxa(physeq_filtered)

# Guardar los tamaños de las muestras antes de la normalización
original_sample_sums <- sample_sums(physeq_filtered)

# Normalización por tamaño de muestra
physeq_normalized <- transform_sample_counts(physeq_filtered, function(x) x / sum(x))

# Calcular la desviación estándar de cada OTU
otu_sd <- apply(otu_table(physeq_normalized), 1, sd)

# Crear un data frame con las desviaciones estándar
df <- data.frame(sd_otus = otu_sd)

# Crear un boxplot de las desviaciones estándar con ggplot2
ggplot(df, aes(y = sd_otus)) +
  geom_boxplot(outlier.colour = 'darkred', outlier.alpha = .7) +
  labs(
    title = "Desviaciones Estándar de las Abundancias de las OTUs",
    y = "Desviación Estándar"
  ) +
  coord_flip() +
  theme_light()

# Calcular los umbrales
low_threshold <- quantile(otu_sd, 0.05)
high_threshold <- quantile(otu_sd, 0.95)

# Filtrado por variabilidad baja
low_var_filter <- function(x) sd(x) >= 0 # umbral
physeq_normalized <- filter_taxa(physeq_normalized, low_var_filter, TRUE)

# Filtrado por variabilidad alta
high_var_filter <- function(x) sd(x) < high_threshold # umbral
physeq_filtered <- filter_taxa(physeq_normalized, high_var_filter, TRUE)

# Volver al formato de conteo
otu_table(physeq_filtered) <- otu_table(physeq_filtered) *
  original_sample_sums[sample_names(physeq_filtered)]

# Número de OTUs después del filtrado
ntaxa_after <- ntaxa(physeq_filtered)

# Guardar el objeto phyloseq filtrado
saveRDS(physeq_filtered, 'data/phyloseq_objects/GlobalPatterns_filtered.RDS')
