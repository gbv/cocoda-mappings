gnd-ddc.ndjson: gnd-ddc.nt
	cat gnd-ddc.nt | node convert.mjs > $@

gnd-ddc.nt:
	curl --silent https://data.dnb.de/opendata/authorities-gnd_lds.nt.gz | zcat - | grep "dewey.info" > $@
