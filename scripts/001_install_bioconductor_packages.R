# Repositorio Bioconductor.
bioc_packages <- c("phyloseq", "dada2", "DECIPHER",
                   "phangorn", "ggpubr", "BiocManager",
                   "DESeq2", "microbiome", "philr", "pheatmap")

.inst <- bioc_packages %in% installed.packages()
