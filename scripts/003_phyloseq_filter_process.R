# Carga de la librería.
library(pacman)

p_load(phyloseq, vegan)

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
# podríamos establecer unas 5 muestras como umbral.
gp_filtered <- filter_taxa(GlobalPatterns, function(x) sum(x) >= 5, TRUE)

# Otra vía para hacer esto sería utilizar la función prune_taxa
prune_taxa(taxa_sums(GlobalPatterns) >= 5, GlobalPatterns)

# Filtrado independiente por presencia en un número mínimo de muestras: 
# se quitan aquellas OTU que no aparezcan en más de X muestras. 

# La opción para eliminar estas OTUs muy raras es también prune_taxa. Esta función de phyloseq
# se utiliza para subconjuntar o "podar" un objeto phyloseq a un conjunto específico
# de taxones (OTUs), y es útil cuando sólo se está interesado en un subconjunto 
# específico de taxones y se quiere eliminar el resto del objeto phyloseq.

# Por ejemplo, podemos eliminar aquellas OTUs que están presentes en menos de 5 muestras
# tal como se ha hecho con filter_taxa con prune_taxa de la siguiente forma. 
prune_taxa(rowSums(otu_table(GlobalPatterns) > 0) >= 5, GlobalPatterns)


