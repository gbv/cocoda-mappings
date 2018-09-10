# RVK in MARCXML

Die RVK wird halbjährlich (?) zur in MARC-XML Verfügung gestellt:

* https://rvk.uni-regensburg.de/regensburger-verbundklassifikation-online/rvk-download

Das verwendete Format ist eine Teilmenge des [MARC 21 Format for Classification Data].

* http://www.loc.gov/marc/classification/
* https://rvk.uni-regensburg.de/api_2.0/marcxml.html

Die verwendeten MARC-Felder und Unterfelder, ermittelt mit:

    catmandu convert MARC --type XML to Breaker --handler marc < rvko_marcxml_2018_2.xml > rvko_2018_2.breaker

Die folgenden Felder können im wesentlichen ignoriert werden:

| Feld   | Anzahl  | Kommentar                         | 
|--------|---------|-----------------------------------|
| LDR    | 861388  | immer gleich                      |
| 001    | 861388  | interne Datensatz-ID              |
| 003    | 861388  | immer gleich                      |
| 005    | 861388  | Datum des Dump                    |
| 008    | 861388  | immer gleich                      |
| 040 $a | 861388  | immer gleich                      |
| 040 $b | 861388  | immer gleich (Sprache)            |
| 040 $c | 861388  | immer gleich                      |
| 040 $d | 861388  | immer gleich                      |
| 084 $a | 861388  | immer gleich                      |

Eine Besonderheit stellt die interne ID in `001` da, da an dieser der
Entitätstyp ermittelt werden könnte. Inse Häusler schrieb dazu:

> Die meisten Autoren müsste man über die Schlüssel und die IDs herausfinden
> können. Z.B. beim Autorenschlüssel P1B sind alle IDs, die .... :11595
> enthalten, oder beim Autorenschlüssel P1C alle IDs, die ... :11598 enthalten,
> den einzelnen Autoren zugeordnet. Aber nicht alle Autoren wiederum sind über
> die Schlüssel zu identifizieren.

Eine eigene Analyse zeigt, dass die Datensatz-ID nicht zur Ermittlung von
Entitätstypen ausreicht.

Die wesentlichen Informationen stehen in diesen Feldern:

| Feld   | Anzahl  | Kommentar                          | 
|--------|---------|------------------------------------|
| 153 $a |  861388 | Notation                		    |
| 153 $c |  104017 | Notation (bei Bereichen)           |
| 153 $e | 5837859 | Übergeordnete Notation(en)         |
| 153 $f | 4449460 | Übergeordnete Notation(en)         |
| 153 $h | 5837859 | Übergeordnete Klassenbenennung(en) |
| 153 $j |  861388 | Klassenbenennung                   |
| 253 $i |   41354 | Siehe-Auch Verweis als Freitext    |
| 684 $i |   68195 | Anwendungshinweis als Freitext     |

Registerbegriffe aus der GND sind nicht für alle Klassen vorhanden, es sind nur
die Unterfelder `$0` (GND-ID + Präfix), `$2` (Hauptbenennung) und `$a` (immer
`gnd`) belegt.

| Feld   | Anzahl  |
|--------|---------|
| 700$0  | 17489   |
| 700$2  | 17489   |
| 700$a  | 17489   |
| 710$0  | 5926    |
| 710$2  | 5926    |
| 710$a  | 5926    |
| 711$0  | 33      |
| 711$2  | 33      |
| 711$a  | 33      |
| 730$0  | 1291    |
| 730$2  | 1291    |
| 730$a  | 1291    |
| 750$0  | 377240  |
| 750$2  | 377240  |
| 750$a  | 377240  |
| 751$0  | 153150  |
| 751$2  | 153150  |
| 751$a  | 153150  |

[MARC 21 Format for Classification Data](http://www.loc.gov/marc/classification/)

## Entitätstypen

Die RVK kennt keine Entitätstypen wie die GND
(siehe [MARC-Normdaten-Feld 075](https://www.loc.gov/marc/authority/concise/ad075.html).
Eine Unterscheidung von RVK-Klassen nach Entitätstyp macht aber Sinn. Insgesondere enthält
die GND sehr viele Klassen zu einzelnen Autor*innen. Bei diesen Klassen kann von einfache 
1-zu-1 Mappings zu anderen Normdateien ausgegangen werden.

### Beispiel

* RVK: [BD 4006 - BD 4007 Aaron ben Elijah (1328-1369)](https://rvk.uni-regensburg.de/regensburger-verbundklassifikation-online#notation/BD%204006%20-%20BD%204007)
* GND: <https://d-nb.info/gnd/104076682>
* Wikidata: <https://www.wikidata.org/wiki/Q302956>

### Arbeitsschritte zum Mapping

1. Ermittlung der RVK-Klassen zu einzelnen Personen
2. Kontextualisierung durch übergeordnete Klassen (z.B. "Das Judentum im Mittelalter") um Personen mit gleichem Namen besser unterscheiden zu können.
3. Mapping (z.B. Wikidata mix'n'match)

Um das Mapping nach Aktualisierungen wiederholen zu können, sollten die Arbeitsschritte möglichts automatisiert ablaufen. 

### Personenklassen

*Update: Mapping mit Wikidata ist jetzt hier verfügbar: <https://tools.wmflabs.org/mix-n-match/#/list/1751>*


Personenklassen strehen anscheinend immer Unter einer Klasse mit einer Benennung wie "Autoren A", "Autoren B" etc. Weitere Personen gibt es unter Klassen wie "Autoren und Denkmäler V" allerdings sind darunter auch andere Entitäten. Aus JSKOS lassen sich diese Überklassen so ermitteln:

    jq -c 'select(.prefLabel.de|match("^Autoren [A-Z]$"))' rvk.ndjson > letters.ndjson

Diese Liste schliesst nicht alle Klassen ein, die einzelne Autoren als Unterklassen zusammmenfassen, aber die meisten von diesen 2114 Klassen (Stand Dump 01/2018) sollten sich alle direkten Unterklassen auf einzelne Autoren beziehen.

Personen-Klassen können wiederum Unterklassen haben z.B.

* BM 6490 - BM 6541 Autoren A
  * BM 6490 - BM 6491 Acostro, Jose de
    * BM 6490 Werke
    * BM 6491 Sekundärliteratur

Eine Zählung des Dumps 2/2018 ergab:

* 24.926 Personen-Klassen
* 66.677 Unterklassen davon

<!--

    jq -s '[.[]|{key:.uri}]|from_entries' letters.ndjson > index.json
    jq --slurpfile l index.json 'select(.broader[0].uri|in($l[0]))' rvk.ndjson > authors.ndjson

Es zeigt sich, dass mindestens 694.903 der 860.881 RVK-Klassen (also mindestens 80%) einzelnen Autoren zugeordnet sind und daher besser auf GND/VIAF/Wikidata statt auf andere Klassifikationen gemappt werden sollten. Wie mit Unterklassen von Autorenklassen umgegangen werden soll, muss noch untersucht werden.

Zum Mapping der Personen-Klassen sollten diese kontextualisiert werden.
-->



### Geografika

Viele Klassen haben geografische Bezüge, allerdings gibt es keine expliziten
Tabellen für Geografika.  So gibt es für einzelne Kontinente, Länder, Städte
etc. mehrere Klassen z.B. für Hochschulen in diesem Gebiet, Geschichte dieses
Gebietes, Ethnologie dieses Gebietes u.v.a.m. Die Filterung nach diesen
Geografischen bezügen ist schwierig.

Die meisten Personen-Klassen sind ebenfalls geografisch untergeordnet.

## Sonstiges

* Einige Klassen scheinen doppelt vorzukommen
* Grundsätzlich macht es Sinn das Mapping zunächst nur bis zu einer beschränkten Ebene vorzunehmen
