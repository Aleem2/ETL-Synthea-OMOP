# ETL-Synthea-OMOP
This repository captures the code and the process of converting synthetic data created using Synthea to OMOP CDM. 
It also captures code to create the data quality dashboard. 

## Performing ETL on Synthea dataset
1. The Synthea dataset is usually in csv files. It has its own standard tables and schema structure. However, this structure does not match the OMOP CDM. 
2. To perform ETL on Synthea dataset, we use the R package OHDSI/ETL-Synthea. The source code is taken from https://github.com/OHDSI/ETL-Synthea.
3. To make the process reproducible, a software container was created with the tag aleem1uddin/hades-data-quality-dashboard:v1.0
4. 
