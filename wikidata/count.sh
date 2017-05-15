#!/bin/bash

set -e
source ./wikidata.sh

for P in "$@"
do
    echo $P
    wdquerytsv "query=SELECT (COUNT(?x) AS ?c) { ?x wdt:$P ?v }"
done
