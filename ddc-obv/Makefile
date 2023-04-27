include ../Makefile

fromScheme=http://bartoc.org/en/node/241
toScheme=http://bartoc.org/en/node/20430
concordance=https://coli-conc.gbv.de/api/concordances/ddc-obv

ddc-obv-mappings.ndjson: ddc-obv-mappings.csv registry.json
	$(jskos-convert) mappings -t ndjson -r registry.json \
		-s http://bartoc.org/en/node/241 -d http://bartoc.org/en/node/20430 \
		-v -p ${concordance} $< > $@
	wc -l $@


SCHEME_FIELDS=uri,identifier,publisher,notation,prefLabel,altLabel,namespace,uriPattern
registry.json:
	(curl -Ls http://bartoc.org/api/data?uri=${fromScheme}; \
	curl -Ls http://bartoc.org/api/data?uri=${toScheme}) \
	| jq -s 'add|{schemes:map({$(SCHEME_FIELDS)}|del(..|nulls))}' > $@ 
