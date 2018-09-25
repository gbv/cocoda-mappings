.PHONY: codelist update

codelist: 
	@curl -s http://id.loc.gov/vocabulary/identifiers.madsrdf.nt \
		| grep 'hasMADSSchemeMember>' \
		| perl -p -e 's!.*/([^/>]+)>.*!$$1!' | sort > $@
	@wc -l $@

update:
	cat codelist | ./count-gnd-mappings.pl >> count-gnd-mappings.csv

# GND-LCSH (project macs)
GNDLCSH=../csv/gnd_lcsh_macs.csv
MACSNT=$(wildcard macs-*.nt.gz)
macs: $(MACSNT) 
	zcat $< | perl macs-gnd2lcsh.pl > $(GNDLCSH) 2> macs.err

# GND-DDC mappings (CrissCross project)
CRISSCROSS=../csv/gnd_ddc_crisscross.csv
GNDTTL=$(wildcard T*.ttl.gz)

crisscross: $(CRISSCROSS)
$(CRISSCROSS): $(GNDTTL)
	zcat $(GNDTTL) | perl gndttl2ddcmappings.pl > $@
