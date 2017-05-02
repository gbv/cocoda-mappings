#!/bin/bash

# count number of indirect mappings for each pair of properties 

for F in P*.csv; do
    P=`basename $F .csv`
    tail -n +2 $F | awk -F, '{print $1}' | sort > $P.ids
done 

echo > tmp.csv
for A in P*.ids; do
    PA=`basename $A .ids`
    for B in P*.ids; do
        PB=`basename $B .ids`
        if [[ "$PA" < "$PB" ]]; then
            COUNT=`join $A $B | wc -l`
            if (( $COUNT > 0 )); then
                echo "$PA,$PB,$COUNT" >> tmp.csv
            fi
        fi
    done
done

sort -r -t, -n -k3 tmp.csv > indirect.csv 
rm tmp.csv
