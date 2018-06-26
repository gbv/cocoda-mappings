# Makefile to convert mappings given as CSV to JSKOS

.SUFFIXES: .csv .ndjson
.PHONY: clean

CSV = $(wildcard *.csv)

ndjson: concordances.ndjson $(CSV:%.csv=%.ndjson)

concordances.ndjson: concordances.yaml kos.yaml
	./concordances2jskos.pl > $@

.csv.ndjson:
	@echo $@
	@php csv2jskos.php $< > $@ 2> $(<:%.csv=%.err)
	@[ -s $(<:%.csv=%.err) ] || rm $(<:%.csv=%.err)

clean:
	rm *.err
