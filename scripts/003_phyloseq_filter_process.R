library(pacman)

p_load(phyloseq, vegan)

# Cargar un objecto phyloseq.
data("GlobalPatterns")

# Inicio del Filtrado

# Filtrado Independiente: se quitan aquellas OTU que no aparezcan 
# en más de X muestras. 
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

Es importante tener en cuenta que el filtrado de OTUs es una decisión que debe basarse en el conocimiento del conjunto de datos y del objetivo del análisis. Es posible que desees experimentar con diferentes valores de X y ver cómo afectan a tus resultados.
Otus97phyl.F1 <- filter_taxa(Otus97phyl, function(x) sum(x) > 100, TRUE)
