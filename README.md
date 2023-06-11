# Andera

## Objetivo del Proyecto

Este proyecto tiene por objeto recoger los diferentes flujos de trabajo realizados para el **análisis de microbiomas** utilizando paquetes de **Bioconductor**.

## Introducción

La **metagenómica** es un campo en plena explosión que se centra en el estudio de la diversidad genética de comunidades de microorganismos presentes en un ambiente específico, ya sea éste el suelo, el agua, la rizosfera o incluso el cuerpo humano. La metagenómica permite de este modo un cambio de enfoque al centrar el estudio de la diversidad y la función de las comunidades microbianas en su conjunto, no como entidades separadas.

**[Bioconductor](https://www.bioconductor.org/)** es una herramienta esencial para el análisis de datos de metagenómica y en concreto para lo que en este proyecto nos ocupa, microbiomas. Proporciona una amplia gama de paquetes de software que permiten el análisis, procesamiento y visualización de datos de secuenciación de alto rendimiento dando la posibilidad a los investigadores de identificar y cuantificar las especies microbianas presentes en una muestra, comparar la diversidad microbiana entre diferentes muestras y explorar las funciones potenciales de las comunidades microbianas así como la interacción entre las especies que la componen.

En este proyecto se presenta una selección de paquetes de Bioconductor que son particularmente útiles para el análisis de metagenómica y microbiomas. Estos paquetes proporcionan herramientas para la manipulación de secuencias de ADN, el manejo de datos genómicos, la interacción con archivos de genoma y servidores de navegadores de genoma, y el análisis de variantes genéticas, entre otras funciones.

Espero que este recurso sea útil para los investigadores y científicos de datos interesados en la metagenómica y el análisis de microbiomas. ¡Bienvenido, amigo!

## Paquetes de Bioconductor

- **[Phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)**:Este paquete es una herramienta fundamental para el análisis de datos de microbiomas. Proporciona una serie de clases y métodos para manipular y visualizar datos taxonómicos y filogenéticos. Phyloseq facilita la importación de datos de una variedad de formatos, y proporciona funciones para la normalización, filtrado, aglomeración, transformación y visualización de datos.

- **[DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)**: Este paquete es útil para el análisis de datos de conteo, como los que se obtienen de experimentos de secuenciación. DESeq2 puede ayudarte a identificar las especies que están significativamente enriquecidas o agotadas en diferentes condiciones o grupos.

- **[edgeR](https://bioconductor.org/packages/release/bioc/html/edgeR.html)**: Similar a DESeq2, edgeR también se utiliza para el análisis de datos de conteo. Puede ser útil para identificar diferencias en la abundancia de especies entre diferentes grupos o condiciones.

- **[vegan](https://cran.r-project.org/web/packages/vegan/index.html)**: Este paquete de R, aunque no es parte de Bioconductor, es una herramienta muy utilizada en el análisis de microbiomas. Proporciona funciones para la diversidad y la ordenación ecológica, incluyendo medidas de diversidad alfa y beta, análisis de componentes principales (PCA), análisis de correspondencia (CA), análisis de correspondencia canónica (CCA) y escalado multidimensional no métrico (NMDS).

- **[picante](https://cran.r-project.org/web/packages/picante/index.html)**: Este paquete de R, aunque no es parte de Bioconductor, proporciona herramientas para el análisis integral de la diversidad y la filogenia comunitaria en R. Es especialmente útil para el análisis de microbiomas.

- **[metagenomeSeq](https://bioconductor.org/packages/release/bioc/html/metagenomeSeq.html)**: Este paquete está diseñado específicamente para el análisis de datos metagenómicos. Proporciona herramientas para el análisis de datos de conteo con ceros en exceso, que son comunes en los estudios de microbiomas.

- **[Biostrings](https://bioconductor.org/packages/release/bioc/html/Biostrings.html)**: Este paquete proporciona herramientas para la manipulación de secuencias de ADN y proteínas. Puede ser útil para el procesamiento y análisis de secuencias de genes de ARNr 16S.

- **[biomformat](https://bioconductor.org/packages/release/bioc/html/biomformat.html)**: Este paquete proporciona una interfaz para el formato BIOM, que es un formato estándar para compartir datos de microbiomas. Puede ser útil para importar y exportar datos en este formato.

- **[microbiome](https://bioconductor.org/packages/release/bioc/html/microbiome.html)**: Este paquete proporciona herramientas para el análisis exploratorio de datos de microbiomas. Incluye funciones para la visualización, normalización y análisis de diversidad de datos de microbiomas.

- **[mia](https://bioconductor.org/packages/release/bioc/html/mia.html)**: Este paquete, que significa "Microbiome Analysis", proporciona una serie de herramientas para el análisis de datos de microbiomas, incluyendo la importación de datos, la normalización, la transformación, la visualización y el análisis estadístico.

- **[ampvis2](https://bioconductor.org/packages/release/bioc/html/ampvis2.html)**: Este paquete es útil para la visualización de datos de amplicones, que son comunes en los estudios de microbiomas. Proporciona una serie de gráficos y visualizaciones útiles para explorar estos datos.

- **[DECIPHER](https://bioconductor.org/packages/release/bioc/html/DECIPHER.html)**: Este paquete es útil para el análisis de secuencias de ADN y ARN. Proporciona herramientas para la alineación de secuencias, la predicción de estructuras de ARN y la clasificación de secuencias.

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


## Bases de Datos 

### [NASA GeneLab: Ciencia Abierta para la Vida en el Espacio](https://genelab.nasa.gov/)

**NASA GeneLab** es la primera base de datos ómicos completa relacionada con el espacio. Es un recurso interactivo y de acceso abierto donde los científicos pueden cargar, descargar, almacenar, buscar, compartir, transferir y analizar datos ómicos de experimentos de vuelo espacial y experimentos analógicos correspondientes.

GeneLab se centra en entender cómo los bloques de construcción fundamentales de la vida misma (ADN, ARN, proteínas y metabolitos) cambian debido a la exposición a la microgravedad, la radiación y otros aspectos del ambiente espacial. Proporciona datos completamente coordinados de epigenómica, genómica, transcriptómica, proteómica y metabolómica, junto con metadatos esenciales que describen cada experimento de vuelo espacial y relevante para el espacio.

El laboratorio juega un papel crítico en nuestra comprensión de cómo el vuelo espacial afecta a los humanos y a otros organismos modelo, como Drosophila y mamíferos. Los datos recopilados de estos modelos permiten capturar una imagen completa de los cambios moleculares asociados con el espacio.Además, la investigación espacial biológica también tiene un impacto en la salud y el bienestar de los humanos en la Tierra. Varias enfermedades que existen en la Tierra, como la osteoporosis, las enfermedades cardíacas, la pérdida de agudeza visual y la aparición de microbios virulentos, parecen acelerarse en el espacio. El estudio de los fundamentos moleculares de la progresión de las enfermedades durante el vuelo espacial puede proporcionar una visión de la aparición de enfermedades similares en la Tierra y avanzar en nuestra comprensión y, posteriormente, en nuestra capacidad para detectar y tratar con éxito tales enfermedades.

### MG-RAST

MG-RAST es una aplicación de servidor de código abierto y de envío abierto que sugiere análisis filogenéticos y funcionales automáticos de metagenomas. También es uno de los mayores repositorios de datos metagenómicos​3​. El servidor de metagenómica RAST es un entorno basado en SEED que permite a los usuarios cargar metagenomas para análisis automatizados​4​.