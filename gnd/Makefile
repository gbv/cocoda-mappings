.PHONY: codelist update

codelist: 
	@curl -s http://id.loc.gov/vocabulary/identifiers.madsrdf.nt \
		| grep 'hasMADSSchemeMember>' \
		| perl -p -e 's!.*/([^/>]+)>.*!$$1!' | sort > $@
	@wc -l $@

update:
	cat codelist | ./count-gnd-mappings.pl >> count-gnd-mappings.csv

../csv/gnd_ddc_crisscross.csv: GND.ttl.gz
	zcat $< | perl gndttl2ddcmappings.pl > $@
