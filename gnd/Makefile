.PHONY: validate codelist update

all: gnd-agrovoc-mappings.ndjson gnd-embne-mappings.ndjson gnd-mesh-mappings.ndjson gnd-nsogg-mappings.ndjson gnd-stw-mappings.ndjson gnd-concordances.ndjson gnd-thesoz-mappings.ndjson

gnd-agrovoc-mappings.ndjson: mapping-authorities-gnd-agrovoc_lds.jsonld.gz
	./etl.sh agrovoc

gnd-embne-mappings.ndjson: mapping-authorities-gnd-embne_lds.jsonld.gz
	./etl.sh embne

gnd-mesh-mappings.ndjson: mapping-authorities-gnd-mesh_lds.jsonld.gz
	./etl.sh mesh

gnd-nsogg-mappings.ndjson: mapping-authorities-gnd-nsogg_lds.jsonld.gz
	./etl.sh nsogg

gnd-thesoz-mappings.ndjson: mapping-authorities-gnd-thesoz_lds.jsonld.gz
	./etl.sh thesoz

gnd-stw-mappings.ndjson: mapping-authorities-gnd-stw_lds.jsonld.gz
	./etl.sh stw

gnd-lcsh-mappings.ndjson: mapping-authorities-gnd-lcsh-ram_lds.jsonld.gz
	./etl.sh lcsh $<

gnd-rameau-mappings.ndjson: mapping-authorities-gnd-lcsh-ram_lds.jsonld.gz
	./etl.sh rameau $<

gnd-concordances.ndjson: validate
	jq -c . *-concordance.json > $@

validate:
	npm run --silent -- jskos-validate --verbose concordance *-concordance.json

codelist: 
	@curl -sL http://id.loc.gov/vocabulary/identifiers.madsrdf.nt \
		| grep 'hasMADSSchemeMember>' \
		| perl -p -e 's!.*/([^/>]+)>.*!$$1!' | sort > $@
	@wc -l $@

update:
	cat codelist | ./count-gnd-mappings.pl >> count-gnd-mappings.csv

download:
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-agrovoc_lds.jsonld.gz
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-embne_lds.jsonld.gz
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-lcsh-ram_lds.jsonld.gz
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-mesh_lds.jsonld.gz
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-nsogg_lds.jsonld.gz
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-stw_lds.jsonld.gz
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-thesoz_lds.jsonld.gz
	wget -N https://data.dnb.de/opendata/mapping-authorities-gnd-lcsh-ram_lds.jsonld.gz

# GND-DDC mappings (CrissCross project)
CRISSCROSS=../csv/gnd_ddc_crisscross.csv
GNDTTL=$(wildcard T*.ttl.gz)

crisscross: $(CRISSCROSS)
$(CRISSCROSS): $(GNDTTL)
	zcat $(GNDTTL) | perl gndttl2ddcmappings.pl > $@
