# DDC-LCSH Mappings

## Requirements
- Catmandu with MARC importer and JSON exporter
- Pansoft-provided source file `lcsh.xml` (MARC XML file of LCSH with DDC links in 083$a)

## Conversion to JSKOS

```bash
make
```

## To-Dos
- [ ] Add `creator` to mappings
- [ ] Better documentation
