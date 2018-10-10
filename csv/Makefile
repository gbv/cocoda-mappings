# Makefile to convert mappings given as CSV to JSKOS

.SUFFIXES: .csv .ndjson
.PHONY: clean

CSV = $(wildcard *_*.csv)

ndjson: concordances.ndjson $(CSV:%.csv=%.ndjson)

concordances.ndjson: concordances.yaml kos.yaml
	./concordances2jskos.pl > $@

.csv.ndjson:
	@echo $@
	@./csv2jskos.pl $< > $@ 2> $(<:%.csv=%.err)
	@[ -s $(<:%.csv=%.err) ] || rm $(<:%.csv=%.err)

clean:
	rm *.ndjson *.err
