# Mappings from and in the GND autority files

RDF Dumps are made available at <https://data.dnb.de/opendata/> for selected vocabularies
(Some additional mappings may be available from full GND dumps).

The RDF dumps provided by DNB contain **raw SKOS mapping statements**, so there is
no data about mappings (stable identifier, date of creation...)!

The data is internally generated from [Tc-Records](https://wiki.dnb.de/pages/viewpage.action?pageId=283803734) - these would allow for stable identifiers and additional mapping data, but these records are not made available by default.

## Usage

Requires Node 20. First install dependencies (call `npm ci` in parent directory).

~~~
make update
make all
~~~


