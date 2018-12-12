library(GenomicDataCommons)
library(tidyverse)
library(conflicted)

# Check status of connection to GDC
GenomicDataCommons::status()

# Set cache directory to data folder of the project
gdc_set_cache(directory = 'data/GDC_data/',
              verbose = T,
              create_without_asking = F)

# Examples
pquery <- projects()
str(pquery)

# TCGA all metastatic samples
response <- cases() %>%
    GenomicDataCommons::filter( ~ project.program.name == 'TCGA' &
                                    samples.sample_type == 'Metastatic') %>%
    GenomicDataCommons::select(c(default_fields(cases()),
                                 'samples.sample_type')) %>%
    response_all()

table(response$results$primary_site)

# All metastatic samples
response <- cases() %>%
    GenomicDataCommons::filter(~ samples.sample_type == 'Metastatic' &
                                   files.type == 'GISTIC') %>%
    GenomicDataCommons::select(c(default_fields(cases()),
                                 'samples.sample_type')) %>%
    response_all()

table(response$results$primary_site)

## 
q <- files() %>%
    GenomicDataCommons::select(available_fields('files')) %>%
    GenomicDataCommons::filter( 
        ~ cases.samples.sample_type == 'Metastatic' &
            data_type == 'Copy Number')

q %>% facet('analysis.workflow_type') %>% aggregations()

ge_manifest = files() %>%
    GenomicDataCommons::filter(
        ~ cases.project.project_id == 'TCGA-PAAD' &
            cases.samples.sample_type == 'Metastatic' &
            type == 'gene_expression' &
            analysis.workflow_type == 'HTSeq - Counts'
    ) %>%
    manifest()


qCases <- cases() %>%
    filter(
        ~ (
            samples.sample_type == "Solid Tissue Normal" |
                samples.sample_type == "Blood Derived Normal"
        ) &
            (
                files.type == 'gene_expression' |
                    files.type == 'methylation_beta_value'
            )
    )

qCases %>% count()










