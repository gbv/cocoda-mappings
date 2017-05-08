This directory contains scripts to harvest, convert, and merge authority file mappings from Wikidata to be published at <https://coli-conc.gbv.de/concordances/wikidata/>.

## Requirements

* wdmapper >= 0.0.15

## Manifest

* ẁikidata.sh - utility functions
* properties.sh - get a list of Wikidata autohority file properties 
* update.sh - cron job to harvest mappings from Wikidata
* indirect.sh - count number of indirect mappings for each pair of properties
* statlog.sh - append stats.csv to statlog.csv with date
