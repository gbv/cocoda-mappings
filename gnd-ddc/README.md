# GND-DDC Mappings from DNB

## Requirements
- Node.js 18+
- Internet access with [this file](https://data.dnb.de/opendata/authorities-gnd_lds.nt.gz) accessible

## Conversion to JSKOS

```bash
make -B
```

## To-Dos
- [ ] Fix skipped mappings (JSKOS Server does not import all the converted mappings, but jskos-validate doesn't show any errors)
- [ ] Can we mint stable URIs so that they don't change whenever we update the mappings?
- [ ] Download data instead of streaming it directly into conversion script
