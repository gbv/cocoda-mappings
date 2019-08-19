#!/bin/bash
set -e

cd $(dirname $(realpath $0))

# cronjobs run without local $PATH environment
WDMAPPER=$(which wdmapper)
WDMAPPER=${WDMAPPER:-/usr/local/bin/wdmapper}

make -B properties.ids

date -Im

set +e # ignore errors

while read p; do
    echo "SELECT (COUNT(?x) AS ?c) { ?x wdt:$p ?v }" > tmp.sparql
    COUNT=$(wd sparql tmp.sparql)
   
    # omit labels for large result sets
    if [ $COUNT -ge 200000 ]; then
        LANGUAGE=
    else
        LANGUAGE=en
    fi

    echo -n "$p "
 
    # harvest mappings with wdmapper
    timeout 240 $WDMAPPER get $p -o tmp.txt -g "$LANGUAGE"
    if [ $? -ne 0 ]; then
        echo "failed (expected $COUNT mappings)"
    else
        mv tmp.txt $p.txt
        head -2 $p.txt | tail -1

        # convert to JSKOS and CSV
        $WDMAPPER convert $p -i $p.txt -o $p.ndjson
        $WDMAPPER convert $p -i $p.txt -o $p.csv
    fi
done < properties.ids


make stats wikidata-concordances.json

php sparklines.php
