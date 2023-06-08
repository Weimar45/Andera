# Carga de la librería .
library(phyloseq)

# Mirar los objetos phyloseq que vienen de fábrica con el paquete.
data(package = 'phyloseq')

# Explorar un objecto phyloseq.
data("GlobalPatterns")
GlobalPatterns

# Identificador de las muestras. 
sample_names(GlobalPatterns) 

# Número de muestras en el objeto phyloseq. 
nsamples(GlobalPatterns)

# Variables que definen la taxonomía.
rank_names(GlobalPatterns) 

# Variables de los metadatos (se suelen definir en un excel).
sample_variables(GlobalPatterns) 

# Número de taxones en el objeto phyloseq.
ntaxa(GlobalPatterns)

# Ver la tabla de Unidades Taxonómicas Operativas (OTUs)
otu_table(GlobalPatterns)[1:5, 1:5]
