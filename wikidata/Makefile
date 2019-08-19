.PHONY: website sparklines growth

CSVDUMPS= $(wildcard P*.csv)

all: stats website

stats: stats.csv statlog.csv growth total.csv indirect.csv indirectlog.csv

# get current list of properties from Wikidata
properties.ndjson:
	wd sparql properties.sparql | jq -c '.[]' > $@

# extract Wikidata property ids
properties.ids: properties.ndjson
	jq -r .prop.value $< > $@


# count number of mappings of each CSV dump
stats.csv: $(CSVDUMPS)
	for F in P*.csv; do \
		wc -l $$F | sed 's/.csv//' | awk '{print $$2","($$1 ? $$1-1 : 0)}' ; \
	done > $@

# append stats to statlog
statlog.csv: stats.csv
	date=`date -I` ;\
	while read -r line;\
		do echo "$$date,$$line"; \
	done < $< >> $@

# extract growth for each property
growth: statlog.csv
	@awk -F, '{print $$2}' statlog.csv | sort | uniq | \
	while read P; do \
		mkdir -p $$P; \
		awk -F, '$$2=$$P{print}' statlog.csv > $$P/growth.csv ;\
	done

# count total number of mappings per date
total.csv: statlog.csv
	awk -F, '!d {d=$$1;s=0} $$1!=d{print d","s; d=$$1;s=0} {s+=$$3} END {print d","s}' < $< > $@


# count number of indirect mappings for each pair of properties 
indirect.csv: $(CSVDUMPS)
	./indirect.sh


# create JSKOS file with summary of all concordances
wikidata-concordances.json: properties.tsv stats.csv
	./concordances.pl

sparklines:
	php sparklines.php

website: wikidata-concordances.json statlog.csv total.csv sparklines
