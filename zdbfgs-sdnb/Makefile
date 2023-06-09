include ../Makefile

fromScheme=http://bartoc.org/en/node/18915
toScheme=http://bartoc.org/en/node/20049
concordance=https://coli-conc.gbv.de/api/concordances/zdb-fgs-sdnb

zdbfgs-sdnb-mappings.ndjson: zdbfgs-sdnb-mappings.csv registry.json
	$(jskos-convert) mappings -t ndjson -r registry.json \
		-s ${fromScheme} -d ${toScheme} \
		-v -p ${concordance} $< > $@
	wc -l $@


SCHEME_FIELDS=uri,identifier,publisher,notation,prefLabel,altLabel,namespace,uriPattern
registry.json:
	(curl -Ls http://bartoc.org/api/data?uri=${fromScheme}; \
	curl -Ls http://bartoc.org/api/data?uri=${toScheme}) \
	| jq -s 'add|{schemes:map({$(SCHEME_FIELDS)}|del(..|nulls))}' > $@ 
