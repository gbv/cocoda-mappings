#!/bin/bash

date=`date -I`
while read -r line; do
    echo "$date,$line"
done < stats.csv >> statlog.csv
