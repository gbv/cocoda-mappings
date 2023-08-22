# DDC-LCSH Mappings
Mappings by OCLC.

## Requirements
- Catmandu with MARC importer and JSON exporter
- Pansoft-provided source file `lcsh.xml` (MARC XML file of LCSH with DDC links in 083$a)

## Conversion to JSKOS

```bash
make
```

## To-Dos
- [x] Add `creator` to mappings
- [ ] Better documentation
- [ ] Allow repeating field 083$a (e.g. for "sh 85035869")
- [ ] Add LCSH `prefLabel` to mapping? (150$a)
