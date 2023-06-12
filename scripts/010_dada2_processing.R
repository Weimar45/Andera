# **Configuración de la Sesións** 

# En primer lugar se definen los paquetes a utilizar en el tutorial, que proceden de CRAN, BioConductor, GitHub y Git. 


## Repositorio CRAN
cran_packages <- c("bookdown", "knitr", "tidyverse", "plyr", "grid", "gridExtra", "kableExtra", "xtable", "ggpubr")

## Repositorio Bioconductor
bioc_packages <- c("phyloseq", "dada2", "DECIPHER", "phangorn", "ggpubr", "BiocManager","DESeq2", "microbiome", "philr")

## Repositorio GitHub
git_source <- c("twbattaglia/btools", "gmteunisse/Fantaxtic", "MadsAlbertsen/ampvis2", "opisthokonta/tsnemicrobiota")

# fuente/nombre del paquete
git_packages <- c("btools", "fantaxtic", "ampvis2", "tsnemicrobiota")

# Instalar paquetes CRAN
.inst <- cran_packages %in% installed.packages()
if(any(!.inst)) {
  install.packages(cran_packages[!.inst])
}

# Intalar paquetes BioConductor
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
.inst <- bioc_packages %in% installed.packages()


if(any(!.inst)) {
  BiocManager::install(bioc_packages[!.inst])
}

# Instalar paquetes GitHub
.inst <- git_source %in% installed.packages()
if(any(!.inst)) {
  devtools::install_github(git_source[!.inst])
}


# Se cargan los paquetes instalados. 

