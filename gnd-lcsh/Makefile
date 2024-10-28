gnd-lcsh.ndjson: gnd-lcsh.nt
	cat gnd-lcsh.nt | node convert.mjs > $@

gnd-lcsh.nt:
	curl --silent https://data.dnb.de/opendata/mapping-authorities-gnd-lcsh-ram_lds.nt.gz | zcat - > $@
