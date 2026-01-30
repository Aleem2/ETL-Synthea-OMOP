# Start the R prompt to install the following packages.
#install.packages("devtools")
# devtools::install_github("OHDSI/ETL-Synthea") # I have manually installed this in the Achilles container with upgrades to other packages. Go to R terminal and execute the install command.

options(java.parameters = "-Xmx20g")


library(ETLSyntheaBuilder)

 # We are loading a version 5.4 CDM into a local PostgreSQL database called "synthea10".
 # The ETLSyntheaBuilder package leverages the OHDSI/CommonDataModel package for CDM creation.
 # Valid CDM versions are determined by executing CommonDataModel::listSupportedVersions().
 # The strings representing supported CDM versions are currently "5.3" and "5.4". 
 # The Synthea version we use in this example is 2.7.0.
 # However, at this time we also support 3.0.0, 3.1.0, 3.2.0 and 3.3.0.
 # Please note that Synthea's MASTER branch is always active and this package will be updated to support
 # future versions as possible.
 # The schema to load the Synthea tables is called "native".
 # The schema to load the Vocabulary and CDM tables is "cdm_synthea10".  
 # The username and pw are "postgres" and "lollipop".
 # The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.

 # For those interested in seeing the CDM changes from 5.3 to 5.4, please see: http://ohdsi.github.io/CommonDataModel/cdm54Changes.html
 
cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql", 
  server   = "203.101.238.252/csiro-db", 
  user     = "csiro", 
  password = "csiro-pass-123",  #<-- not actual password
  port     = 5432 #, 
  # pathToDriver = "d:/drivers"  
)

cdmSchema      <- "cdm_synthea10" #Keep it as it is. This is the name of a database that needs to exist in the postgres. 
cdmVersion     <- "5.4"  # we can assume this. 
syntheaVersion <- "3.3.0"  # I don't know the version ! 2.7.0 failed because of the schema in allergies table. 
syntheaSchema  <- "native"
syntheaFileLoc <- "/opt/achilles/workspace/CSIRO-Full" # correct path
vocabFileLoc   <- "/opt/achilles/workspace/vocab" # I don't have Vocab files yet. Freshly downloaded on 22-8-2025.

ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)
gc()                                    
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
gc()                                      
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaFileLoc = syntheaFileLoc)
gc()                                   
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, cdmSchema = cdmSchema, vocabFileLoc = vocabFileLoc)
gc()
ETLSyntheaBuilder::CreateMapAndRollupTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)
print("ETL process Completed")
gc()
## Optional Step to create extra indices
#ETLSyntheaBuilder::CreateExtraIndices(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
                                    
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)