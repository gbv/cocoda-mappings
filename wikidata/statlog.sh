#!/bin/bash

# append stats to statlog
date=`date -I`
while read -r line; do
    echo "$date,$line"
done < stats.csv >> statlog.csv

# count total number of mappings per date
awk -F, '!d {d=$1;s=0} $1!=d{print d","s; d=$1;s=0} {s+=$2} END {print d","s}' \
    < statlog.csv > total.csv
