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
make gnd-etiras-mappings.ndjson
```

## Code Erklärung

Mit pica select werden alle Felder mit ETIRAS-Notation (\*P.u) und deren Mappingtypen (\*P.4) zu einer GND-Notation (039A.0) extrahiert. Noch nicht aufgelöste NID-Angaben stehen in 039A.5 und werden bei Bedarf übernommen. Die PPN des Mappings befindet sich in 003@.0, das Erstellungsdatum in 001A.0.

Ein Python-Skript entfernt leere Felder, und verschiedene sed-Befehle bereinigen die CSV weiter: Datumsangaben werden ins ISO-Format konvertiert, Sonderzeichen korrigiert und eindeutige Mapping-URIs erzeugt, sodass die Datei für die Konvertierung in JSKOS vorbereitet ist.

Die Schemata von GND (fromScheme) und ETIRAS (toScheme) werden in einer registry.json zusammengeführt, die als Referenz für die NDJSON-Erzeugung dient. Mit jskos-convert wird die bereinigte CSV schließlich in eine JSKOS-konforme NDJSON-Datei umgewandelt.

Nachdem die CSV erstellt wurde, genügt der Befehl **make gnd-etiras-mappings.ndjson**, woraufhin Make automatisch die Registry-Datei erstellt und die NDJSON-Datei gnd-etiras-mappings.ndjson erzeugt.