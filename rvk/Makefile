VERSION ?= 2024_3

XML := rvko_marcxml_$(VERSION).xml.gz
URL := https://rvk.uni-regensburg.de/downloads/rvko_marcxml_$(VERSION).xml.gz
NDJSON := rvk-gnd_$(VERSION).ndjson

$(NDJSON): $(XML)
	deno -v && cat $(XML) | zcat - | DENO_NO_PACKAGE_JSON=1 deno run extract-gnd.js > $@ || echo "deno not found. Please install it: https://docs.deno.com/runtime/"

$(XML):
	curl --silent $(URL) > $@
