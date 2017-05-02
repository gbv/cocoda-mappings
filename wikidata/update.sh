#!/bin/bash

# cronjobs run without local $PATH environment
WDMAPPER=/usr/local/bin/wdmapper

cd $(dirname $(realpath $0))
date -Im

set +e # ignore errors

while read p; do
    echo -n "$p "
    timeout 240 $WDMAPPER get $p -o tmp.txt
    if [ $? -ne 0 ]; then
        echo "failed"
    else
        mv tmp.txt $p.txt
        head -2 $p.txt | tail -1

        # convert to JSKOS, CSV, and HTML
        $WDMAPPER convert $p -i $p.txt -o $p.ndjson
        $WDMAPPER convert $p -i $p.txt -o $p.csv
        # $WDMAPPER convert $p -i $p.txt -t markdown | pandoc -s -S -o $p.html
    fi
done < properties.csv

# count
for F in P*.csv; do
  wc -l $F | sed 's/.csv//;s/ /,/'
done > stats.csv

# save counts with date
date=`date -I`
while read -r line; do
    echo "$date,$line"
done < stats.csv >> statlog.csv

