# ETL-Synthea-OMOP

This repository captures the code and the process of converting synthetic data created using Synthea to OMOP CDM. It also captures code to create the data quality dashboard.

## Performing ETL on the Synthea dataset

1. The Synthea dataset is usually in csv files. It has its own standard tables and schema structure. However, this structure does not match the OMOP CDM.  
2. To perform ETL on the Synthea dataset, we use the R package OHDSI/ETL-Synthea. The source code is taken from [https://github.com/OHDSI/ETL-Synthea](https://github.com/OHDSI/ETL-Synthea).  
3. To make the process reproducible, a software container was created with the tag [aleem1uddin/hades-data-quality-dashboard:v1.0](https://hub.docker.com/r/aleem1uddin/hades-data-quality-dashboard)  
4. This container can be executed using Docker or Kubernetes with Synthea CSV’s data and ETL scripts mounted in a volume. A script to run this container on Docker is captured [achilles-docker-run.txt](achilles-docker-run.txt)  
5. ETL script purpose and use.  
   1. The ETL script uses the R packages that are already installed in the container.   
   2. The [sample R script](ETL-Synthea-CSIRO-Full.R) is self-explanatory, but for the sake of simplicity, it does two tasks. Firstly, connect to the CDM database with proper connection details. Secondly, it loads the raw CSVs into the CDM DB and performs the ETL.   
   3. The final result is a Synthea dataset translated to OMOP CDM.   
6. To integrate this ETLed dataset with ATLAS, three more steps need to be performed.  
   1. Run Achilles on the ETLed dataset to create a results table. [A sample script is captured here](achilles-run-CSIRO-Full.R). Note that the container already has the required packages installed.   
   2. Next, ATLAS requires CDM v5.3 to be further transformed using SQL queries. This SQL script was created following the process outlined in the GitHub repo linked [https://github.com/OHDSI/WebAPI/wiki/CDM-Configurationresults-schema-tables](https://github.com/OHDSI/WebAPI/wiki/CDM-Configurationresults-schema-tables).  
   3. This link also captures the process of integrating a fresh CDM onto the ATLAS implementation. 

## Data Quality Dashboard

1. The process of creating the data quality dashboard is very similar to the ETL process. It is another R package that requires executing an R script.   
2. The R script for evaluating the quality of the [ETLed OMOP dataset is here](DQD-ARDC-12K.R).  
3. The result can be viewed as an R Shiny dashboard exported as a csv file.   
   * To view the Shiny dashboard, [execute the command](Hades-docker-run.txt) to run the container and point to the link in the browser.
   * A sample file showing results of DQD run on CSIRO 12k data set is linked [here](dqd_results_ARDC.csv)
