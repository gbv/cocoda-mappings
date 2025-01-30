# Mappings from and in the GND autority files

RDF Dumps are made available at <https://data.dnb.de/opendata/> for selected vocabularies
(Some additional mappings may be available from full GND dumps).


## Usage

Requires Node 20. First install dependencies (call `npm ci` in parent directory).

~~~
make update
make all
~~~

## Notes

The RDF dumps provided by DNB contain raw SKOS mapping statements, so there is
no data about mappings (stable identifier, date of creation...).
