#!/bin/bash

set -e # die on errors

BASE=https://query.wikidata.org/sparql
QUERY=properties.sparql
FORMAT='text/tab-separated-values'

curl -X POST $BASE --data-urlencode query@$QUERY -H "Accept: $FORMAT" \
	| sed 's/<[^>]\+\/\|>//g' | tail -n +2 > properties.tsv 

awk '{print $1}' properties.tsv > properties.csv
