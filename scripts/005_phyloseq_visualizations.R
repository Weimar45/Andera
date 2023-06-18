
# Gráficos:
# Transformar en relativa para los barplots:
# plot_bar(Otus97phyl.Gen, fill = "Genus")
plot_bar(Otus97phyl.F4, fill = "Phylum") # No se ve nada. Demasiadas muestras. 


# Reagrupar por semana y por genotipo:
Otus97phyl.Stage <- merge_samples(Otus97phyl.F4, "Stage")
Otus97phyl.Canola <- merge_samples(Otus97phyl.F4, "CanolaLine")

# Vemos qué phyla son más abundantes:
title="Phyla por Estadio"
plot_bar(Otus97phyl.Stage, fill = "Phylum", title = title) # Por semana.
title="Phyla por Genotipo"
plot_bar(Otus97phyl.Canola, fill = "Phylum", title = title) # POr genotipo.
title="Familia por Estadio para los phyla del artículo"
plot_bar(subset_taxa(Otus97phyl.Stage, Phylum %in% c("p:Acidobacteria", "p:Firmicutes", "p: Actinobacteria", "p: Bacteroides", "p:Proteobacteria",
                                                     "p:Chloroflexi")), fill = "Family", title = title)
title="Familia por Genotipo para los phyla del artículo"
plot_bar(subset_taxa(Otus97phyl.Canola, Phylum %in% c("p:Acidobacteria", "p:Firmicutes", "p: Actinobacteria", "p: Bacteroides", "p:Proteobacteria",
                                                      "p:Chloroflexi")), fill = "Family", title = title)

# En porcentaje:
Otus97phyl.Stage.Percent <- transform_sample_counts(Otus97phyl.Stage, function(x) x / sum(x) )
Otus97phyl.Canola.Percent <- transform_sample_counts(Otus97phyl.Canola, function(x) x / sum(x))

title="Phyla por Estadio (%)"
plot_bar(Otus97phyl.Stage.Percent, fill = "Phylum", title = title) # Por semana.
title="Phyla por Genotipo (%)"
plot_bar(Otus97phyl.Canola.Percent, fill = "Phylum", title = title) # Por genotipo.
title="Familia por Estadio para los phyla del artículo (%)"
plot_bar(subset_taxa(Otus97phyl.Stage.Percent, Phylum %in% c("p:Acidobacteria", "p:Firmicutes", "p: Actinobacteria", "p: Bacteroides", "p:Proteobacteria",
                                                             "p:Chloroflexi")), fill = "Family", title = title)
title="Familia por Genotipo para los phyla del artículo (%)"
plot_bar(subset_taxa(Otus97phyl.Canola.Percent, Phylum %in% c("p:Acidobacteria", "p:Firmicutes", "p: Actinobacteria", "p: Bacteroides", "p:Proteobacteria",
                                                              "p:Chloroflexi")), fill = "Family", title = title)

# Sin merge: Sepierde con ella precisión. Pierdes los outlier.
Otus97phyl.F4.Glom = tax_glom(Otus97phyl.F4, "Phylum") # Con esto se deja de trabajar co OTUS, se trabaja con Phylum.
Otus97phyl.F4.Glom.Percent <- transform_sample_counts(Otus97phyl.F4.Glom, function(x) x / sum(x))
title="Phyla (%)"
P<-plot_bar(Otus97phyl.F4.Glom.Percent, fill = "Phylum", title = title) # Por semana.
P+facet_grid(.~ Stage, drop = TRUE, scales = "free", space = "free_x")