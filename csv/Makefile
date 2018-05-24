# Makefile to convert mappings given as CSV to JSKOS

.SUFFIXES: .csv .ndjson
.PHONY: clean

CSV = $(wildcard *.csv)

ndjson: concordances.ndjson $(CSV:%.csv=%.ndjson)

concordances.ndjson: concordances.tsv
	php concordances2jskos.php > $@

.csv.ndjson:
	php csv2jskos.php $< > $@ 2> $(<:%.csv=%.err)

clean:
	rm *.err
