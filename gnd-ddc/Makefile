
gnd-ddc.ndjson:
	curl --silent https://data.dnb.de/opendata/authorities-gnd_lds.nt.gz | zcat - | grep "dewey.info" | node convert.mjs > gnd-ddc.ndjson
