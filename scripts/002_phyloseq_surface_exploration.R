# Carga de la librería.
library(pacman)
p_load(phyloseq, pheatmap, ggplot2)

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

# Resumen de la tabla de taxonomía del objeto phyloseq.
head(tax_table(GlobalPatterns))
View(tax_table(GlobalPatterns))

# Resumen de los metadatos de las muestras del objeto phyloseq. 
head(sample_data(GlobalPatterns))
View(sample_data(GlobalPatterns))

# Análisis de la abundancia de taxones
taxa_sums <- taxa_sums(GlobalPatterns)
print(head(sort(taxa_sums, decreasing = TRUE))) # Taxones más abundantes
print(head(sort(taxa_sums, decreasing = FALSE))) # Taxones menos abundantes

# Análisis de la abundancia de muestras
sample_sums <- sample_sums(GlobalPatterns)
print(head(sort(sample_sums, decreasing = TRUE))) # Muestras más abundantes
print(head(sort(sample_sums, decreasing = FALSE))) # Muestras menos abundantes

# Visualización de los datos
# Gráfico de barras de la abundancia de los taxones
# Añado un filtro en este tutorial para que no sea computacionalmente limitante. 
main_gp <- prune_taxa(taxa_names(subset_taxa(GlobalPatterns,
                                             Genus %in% c("Acinetobacter",
                                                          "Bacteroides",
                                                          "Bifidobacterium",
                                                          "Clostridium",
                                                          "Desulfovibrio",
                                                          "Lactobacillus",
                                                          "Massilia"))), 
                      GlobalPatterns)

plot_bar(main_gp, fill = "Phylum") + 
  theme_light() +
  theme(axis.text.x = element_text(angle = 90))

# Mapa de calor de las abundancias de las OTUs
# Transformar la tabla de OTUs en una matriz de log-transformed counts.
otu_matrix <- otu_table(main_gp)
log_otu_matrix <- log1p(otu_matrix) # Añade 1 para evitar el logaritmo de cero

# Finalmente, puedes generar el mapa de calor.
pheatmap(log_otu_matrix)
