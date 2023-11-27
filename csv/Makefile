# Makefile to convert mappings given as CSV to JSKOS

.SUFFIXES: .csv .ndjson
.PHONY: clean

CSV = $(wildcard *_*.csv)

ndjson: $(CSV:%.csv=%.ndjson)

concordances.ndjson: concordances.yaml ../kos.yaml
	./concordances2jskos.pl > $@

.csv.ndjson:
	@echo $@
	@./csv2jskos.pl $< > $@ 2> $(<:%.csv=%.err)
	@sort $@ | uniq -D >> $(<:%.csv=%.err) # duplicated mappings
	@[ -s $(<:%.csv=%.err) ] || rm $(<:%.csv=%.err)
	@make -B --no-print-directory concordances.ndjson > /dev/null

clean:
	rm *.ndjson *.err
