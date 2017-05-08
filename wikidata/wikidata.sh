#!/bin/bash

# Call Wikidata query service with SPARQL query
function wdquerytsv {
    BASE=https://query.wikidata.org/sparql
    FORMAT='text/tab-separated-values'

    curl -sX POST $BASE --data-urlencode "$1" -H "Accept: $FORMAT"
}
