#!/bin/bash

curl https://coli-conc.gbv.de/api/concordances/?download=ndjson > concordances.ndjson

#ddc_bk_chem
#ddc_rvk_1000
#rvk_ddc_cl-cz
#rvk_ddc_philo_psych

#Alle Fälle als RegEx: [a-z]*_[a-z]*_[a-z0-9-]*_?[a-z]*

cat concordances.ndjson | jq -r .notation[] > mappingnames.txt
#cat concordances.ndjson | egrep -o "[a-z]*_[a-z]*_[a-z0-9-]*_?[a-z]*&download=ndjson" > mappingnames.txt

