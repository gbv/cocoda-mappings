#!/bin/bash

set -e
source ./wikidata.sh

wdquerytsv "query@properties.sparql" | tail -n +2 > properties.tsv

awk '{print $1}' properties.tsv \
    | sed 's/<[^>]\+\/\|>//g' \
    | sort | uniq > properties.ids
