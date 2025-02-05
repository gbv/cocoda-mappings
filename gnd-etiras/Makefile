gnd-etiras-mappings.csv:
	pica select -H "022P.u,030P.u,041P.u,065P.u,022P.4,030P.4,041P.4,065P.4,039A.0,039A.5,uri,created" \
	-s "022P.u,030P.u,041P.u,065P.u,022P.4,030P.4,041P.4,065P.4,039A.0,039A.5,003@.0,001A.0" \
	Tc-etiras_Stand_2024-11-13.dat > gnd-etiras-mappings.csv
	python3 rmdup.py
	sed -i 's/[0-9]*://g' gnd-etiras-mappings.csv
	sed -Ei 's/([0-9]{2})-([0-9]{2})-([0-9]{2})/20\3-\2-\1/' gnd-etiras-mappings.csv
	sed -i 's|http//uri.gbv.de/terminology/etiras/||g' gnd-etiras-mappings.csv
	sed -i '1!s/^/https:\/\/coli-conc.gbv.de\/api\/mappings\/gnd-etiras-/' gnd-etiras-mappings.csv
	sed -i -e 's/ftaa/≈/g' -e 's/ftae/=/g' -e 's/ftai/≈/g' -e 's/ftob/>/g' -e 's/ftub/</g' -e 's/ftvb/~/g' -e 's/ftao/≈/g' gnd-etiras-mappings.csv
	# TODO Releationstypen ftau, frao, ftnu

include ../Makefile

fromScheme=http://bartoc.org/en/node/430
toScheme=http://bartoc.org/en/node/248
concordance=https://coli-conc.gbv.de/api/concordances/gnd-etiras

gnd-etiras-mappings.ndjson: gnd-etiras-mappings.csv registry.json
	$(jskos-convert) mappings -t ndjson -r registry.json \
		-s ${fromScheme} -d ${toScheme} \
		-v -p ${concordance} $< > $@
	wc -l $@


SCHEME_FIELDS=uri,identifier,publisher,notation,prefLabel,altLabel,namespace,uriPattern
registry.json:
	(curl -Ls http://bartoc.org/api/data?uri=${fromScheme}; \
	curl -Ls http://bartoc.org/api/data?uri=${toScheme}) \
	| jq -s 'add|{schemes:map({$(SCHEME_FIELDS)}|del(..|nulls))}' > $@ 

