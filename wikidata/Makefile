CSVDUMPS= $(wildcard P*.csv)

all: stats wikidata-concordances.json

stats: stats.csv statlog.csv total.csv indirect.csv indirectlog.csv
	

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

# count total number of mappings per date
total.csv: statlog.csv
	awk -F, '!d {d=$$1;s=0} $$1!=d{print d","s; d=$$1;s=0} {s+=$$3} END {print d","s}' < $< > $@


# count number of indirect mappings for each pair of properties 
indirect.csv: $(CSVDUMOPS)
	./indirect.sh


# create JSKOS file with summary of all concordances
wikidata-concordances.json: properties.tsv stats.csv
	php concordances.php
