#!/usr/bin/env bash
set -ueo pipefail

voc=$1
dump=mapping-authorities-gnd-${voc}_lds.jsonld.gz
result=gnd-$voc-mappings.ndjson

wget -qN https://data.dnb.de/opendata/$dump
zcat $dump | ./jsonld2jskos.mjs $voc > _$result
[ ! -s _$result ] && echo "no mappings found!" && exit 1
npm run --silent jskos-validate mappings _$result
mv _$result $result
wc -l $result
