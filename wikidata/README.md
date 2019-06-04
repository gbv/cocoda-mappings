This directory contains scripts to harvest, convert, and merge authority file mappings from Wikidata to be published at <https://coli-conc.gbv.de/concordances/wikidata/>.

## Requirements

* wdmapper >= 0.0.15
* PHP >= 7.0 with extensions listed in `../composer.json`

## Manifest

* ẁikidata.sh - utility functions
* properties.sh - get a list of Wikidata autohority file properties 
* update.sh - cron job to harvest mappings from Wikidata
* indirect.sh - count number of indirect mappings for each pair of properties
* statlog.sh - append stats.csv to statlog.csv with date
* concordances.php - collect information about all mappings to be shown in HTML

## Processing with jq
    $ cat ~/Dokumente/wikicite-data/20190520/wikidata-20190520-all.json.gz | zcat | jq -nc --stream 'include "wikidata"; ndjson'  |  jq -f -c extract_WD-IDs.jq | jq 'select(length>1)'
