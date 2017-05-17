#!/bin/bash

set -e
source ./wikidata.sh

# get TSV without header, sorted and uniq by ID
wdquerytsv "query@properties.sparql" \
    | tail -n +2 \
    | sort -u -t$'\t' -k1,1 \
    > properties.tsv

awk '{print $1}' properties.tsv \
    | sed 's/<[^>]\+\/\|>//g' \
    | sort > properties.ids
