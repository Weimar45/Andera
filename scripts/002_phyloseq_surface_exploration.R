#
library(phyloseq)

# Explorar un objecto phyloseq
data("GlobalPatterns")
GlobalPatterns

# Identificador de las muestras
sample_names(GlobalPatterns) 

# Variables que definen la taxonomía. 
rank_names(GlobalPatterns) 

# Variables de los metadatos (se suelen definir en la data sheet).
sample_variables(GlobalPatterns) 
