.PHONY: validate codelist update

# TODO
# gnd-thesoz-mappings.ndjson
# gnd-lcsh-mappings.ndjson 
# gnd-rameau-mappings.ndjson 

all: gnd-agrovoc-mappings.ndjson gnd-embne-mappings.ndjson gnd-mesh-mappings.ndjson gnd-nsogg-mappings.ndjson gnd-stw-mappings.ndjson gnd-concordances.ndjson

gnd-agrovoc-mappings.ndjson:
	./etl.sh agrovoc

gnd-embne-mappings.ndjson:
	./etl.sh embne

gnd-mesh-mappings.ndjson:
	./etl.sh mesh

gnd-nsogg-mappings.ndjson:
	./etl.sh nsogg

gnd-thesoz-mappings.ndjson:
	./etl.sh thesoz

gnd-stw-mappings.ndjson:
	./etl.sh stw

gnd-lcsh-mappings.ndjson:
	./etl.sh lcsh

gnd-rameau-mappings.ndjson:
	./etl.sh rameau

gnd-concordances.ndjson: validate
	jq -c . *-concordance.json > $@

validate:
	npm run --silent -- jskos-validate --verbose concordance *-concordance.json

codelist: 
	@curl -s http://id.loc.gov/vocabulary/identifiers.madsrdf.nt \
		| grep 'hasMADSSchemeMember>' \
		| perl -p -e 's!.*/([^/>]+)>.*!$$1!' | sort > $@
	@wc -l $@

update:
	cat codelist | ./count-gnd-mappings.pl >> count-gnd-mappings.csv

# GND-DDC mappings (CrissCross project)
CRISSCROSS=../csv/gnd_ddc_crisscross.csv
GNDTTL=$(wildcard T*.ttl.gz)

crisscross: $(CRISSCROSS)
$(CRISSCROSS): $(GNDTTL)
	zcat $(GNDTTL) | perl gndttl2ddcmappings.pl > $@
