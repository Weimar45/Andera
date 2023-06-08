# Andera

## Objetivo del Proyecto

Este proyecto tiene por objeto recoger los diferentes flujos de trabajo realizados para el **análisis de microbiomas** utilizando paquetes de **Bioconductor**.

## Introducción

La **metagenómica** es un campo en plena explosión que se centra en el estudio de la diversidad genética de comunidades de microorganismos presentes en un ambiente específico, ya sea éste el suelo, el agua, la rizosfera o incluso el cuerpo humano. La metagenómica permite de este modo un cambio de enfoque al centrar el estudio de la diversidad y la función de las comunidades microbianas en su conjunto, no como entidades separadas.

**[Bioconductor](https://www.bioconductor.org/)** es una herramienta esencial para el análisis de datos de metagenómica y en concreto para lo que en este proyecto nos ocupa, microbiomas. Proporciona una amplia gama de paquetes de software que permiten el análisis, procesamiento y visualización de datos de secuenciación de alto rendimiento dando la posibilidad a los investigadores de identificar y cuantificar las especies microbianas presentes en una muestra, comparar la diversidad microbiana entre diferentes muestras y explorar las funciones potenciales de las comunidades microbianas así como la interacción entre las especies que la componen.

En este proyecto se presenta una selección de paquetes de Bioconductor que son particularmente útiles para el análisis de metagenómica y microbiomas. Estos paquetes proporcionan herramientas para la manipulación de secuencias de ADN, el manejo de datos genómicos, la interacción con archivos de genoma y servidores de navegadores de genoma, y el análisis de variantes genéticas, entre otras funciones.

Espero que este recurso sea útil para los investigadores y científicos de datos interesados en la metagenómica y el análisis de microbiomas. ¡Bienvenido, amigo!

## Paquetes de Bioconductor

- **[Phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)**: Este paquete es una herramienta fundamental para el análisis de datos de microbiomas.

- **[DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)**: Este paquete es útil para el análisis de datos de conteo.

- **[edgeR](https://bioconductor.org/packages/release/bioc/html/edgeR.html)**: Similar a DESeq2, edgeR también se utiliza para el análisis de datos de conteo.

- **[vegan](https://cran.r-project.org/web/packages/vegan/index.html)**: Este paquete de R, aunque no es parte de Bioconductor, es una herramienta muy utilizada en el análisis de microbiomas. Proporciona funciones para la diversidad y la ordenación ecológica, incluyendo medidas de diversidad alfa y beta, análisis de componentes principales (PCA), análisis de correspondencia (CA), análisis de correspondencia canónica (CCA) y escalado multidimensional no métrico (NMDS).

- **[picante](https://cran.r-project.org/web/packages/picante/index.html)**: Este paquete de R, aunque no es parte de Bioconductor, proporciona herramientas para el análisis integral de la diversidad y la filogenia comunitaria en R. Es especialmente útil para el análisis de microbiomas.

- **[metagenomeSeq](https://bioconductor.org/packages/release/bioc/html/metagenomeSeq.html)**: Este paquete está diseñado específicamente para el análisis de datos metagenómicos.

- **[Biostrings](https://bioconductor.org/packages/release/bioc/html/Biostrings.html)**: Este paquete proporciona herramientas para la manipulación de secuencias de ADN y proteínas.

- **[biomformat](https://bioconductor.org/packages/release/bioc/html/biomformat.html)**: Este paquete proporciona una interfaz para el formato BIOM.

- **[microbiome](https://bioconductor.org/packages/release/bioc/html/microbiome.html)**: Este paquete proporciona herramientas para el análisis exploratorio de datos de microbiomas.

- **[mia](https://bioconductor.org/packages/release/bioc/html/mia.html)**: Este paquete, que significa "Microbiome Analysis", proporciona una serie de herramientas para el análisis de datos de microbiomas.

- **[ampvis2](https://bioconductor.org/packages/release/bioc/html/ampvis2.html)**: Este paquete es útil para la visualización de datos de amplicones.

- **[DECIPHER](https://bioconductor.org/packages/release/bioc/html/DECIPHER.html)**: Este paquete es útil para el análisis de secuencias de ADN y ARN.

- **[DirichletMultinomial](https://bioconductor.org/packages/release/bioc/html/DirichletMultinomial.html)**: Este paquete proporciona métodos para modelar datos de microbiomas utilizando mezclas de distribuciones Dirichlet-Multinomial.

- **[dada2](https://bioconductor.org/packages/release/bioc/html/dada2.html)**: Este paquete proporciona métodos para el análisis de datos de secuenciación de amplicones.

- **[ANCOMBC](https://bioconductor.org/packages/release/bioc/html/ANCOMBC.html)**: Este paquete proporciona métodos para el análisis de abundancia diferencial en datos de microbiomas con corrección de sesgo.

- **[ALDEx2](https://bioconductor.org/packages/release/bioc/html/ALDEx2.html)**: Este paquete proporciona métodos para el análisis de la abundancia diferencial en datos de microbiomas, teniendo en cuenta la variación de la muestra.

- **[Maaslin2](https://bioconductor.org/packages/release/bioc/html/Maaslin2.html)**: Este paquete proporciona métodos para el análisis de asociaciones multivariables en estudios meta-ómicos a escala de población.

- **[MicrobiotaProcess](https://bioconductor.org/packages/release/bioc/html/MicrobiotaProcess.html)**: Este paquete proporciona una serie de herramientas para gestionar y analizar datos de microbiomas y otros datos ecológicos dentro del marco ordenado.

- **[microbiomeMarker](https://bioconductor.org/packages/release/bioc/html/microbiomeMarker.html)**: Este paquete es un kit de herramientas para el análisis de biomarcadores de microbiomas.

- **[lefser](https://bioconductor.org/packages/release/bioc/html/lefser.html)**: Este paquete es una implementación en R del método LEfSE para el descubrimiento de biomarcadores de microbiomas.

- **[philr](https://bioconductor.org/packages/release/bioc/html/philr.html)**: Este paquete proporciona métodos para la transformación basada en la partición filogenética ILR para datos metagenómicos.

- **[miaViz](https://bioconductor.org/packages/release/bioc/html/miaViz.html)**: Este paquete proporciona métodos para la visualización y el trazado del análisis de microbiomas.

- **[SIAMCAT](https://bioconductor.org/packages/release/bioc/html/SIAMCAT.html)**: Este paquete permite la inferencia estadística de asociaciones entre comunidades microbianas y fenotipos del huésped.

- **[animalcules](https://bioconductor.org/packages/release/bioc/html/animalcules.html)**: Este paquete es un kit de herramientas interactivo para el análisis de microbiomas.

- **[bugsigdbr](https://bioconductor.org/packages/release/bioc/html/bugsigdbr.html)**: Este paquete permite el acceso desde R a firmas microbianas publicadas en BugSigDB.

- **[MMUPHin](https://bioconductor.org/packages/release/bioc/html/MMUPHin.html)**: Este paquete proporciona métodos de meta-análisis con un pipeline uniforme para la heterogeneidad en estudios de microbiomas.

- **[countsimQC](https://bioconductor.org/packages/release/bioc/html/countsimQC.html)**: Este paquete permite comparar características de conjuntos de datos de conteo.

- **[MicrobiomeProfiler](https://bioconductor.org/packages/release/bioc/html/MicrobiomeProfiler.html)**: Este paquete es una aplicación R/shiny para el análisis de enriquecimiento funcional de microbiomas.

- **[microbiomeExplorer](https://bioconductor.org/packages/release/bioc/html/microbiomeExplorer.html)**: Este paquete es una aplicación para la exploración de microbiomas.

- **[miaSim](https://bioconductor.org/packages/release/bioc/html/miaSim.html)**: Este paquete proporciona métodos para la simulación de datos de microbiomas.

- **[PERFect](https://bioconductor.org/packages/release/bioc/html/PERFect.html)**: Este paquete proporciona métodos de filtración de permutaciones para datos de microbiomas.

- **[sparseDOSSA](https://bioconductor.org/packages/release/bioc/html/sparseDOSSA.html)**: Este paquete permite la simulación de abundancias sintéticas para datos escasos (*sparse*).