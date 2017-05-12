all: wikidata-concordances.json

wikidata-concordances.json: properties.tsv stats.csv
	php concordances.php
