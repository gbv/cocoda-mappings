# GND-ETIRAS Mappings

## Requirements
- [pica-rs](https://github.com/deutsche-nationalbibliothek/pica-rs)
- python3
- pip install -r requirements.txt

## Conversion to CSV
```bash
make
```

## Conversion to JSKOS
```bash
gnd-etiras-mappings.ndjson
```

## Code Erklärung
Mit pica select werden alle Felder mit ETIRAS-Notation (\*P.u) und deren Mappingtypen (\*P.4) zu einer GND-Notation (039A.0) gefunden. Noch ausstehende Auflösung der NID-Angaben sind in 039A.5 zu finden und werden in diesen Fällen übernommen.  
003@.0 enthält die PPN, des Mappings, 001A.0 enthält das Erstellungsdatum.  
Mit einem Python-Script werden leere Felder entfernt. sed-Befehle enthalten Änderungen um die CSV-Datei in JSKOS umwandeln zu können.  
