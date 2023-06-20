# Carga de la librería.
library(pacman)

p_load(phyloseq, vegan, ggplot2)

# Cargar un objecto phyloseq.
physeq_filtered <- readRDS('data/phyloseq_objects/GlobalPatterns_filtered.RDS')

# 