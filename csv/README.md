This directory `csv` contains concordances and mappings from different sources.

The base format are CSV files with the following conventions:

* semicolon (`;`) is used as field separator
* field values are not escaped or quoted
* file names have form `SOURCE_TARGET_TEXT.csv` where
    * `SOURCE` is a lowercase, mnemonic id of the source KOS
    * `TARGET` is a lowercase, mnemonic id of the target KOS
    * `TEXT` is a brief additional description of the concordance
* supported fields are
    * `sourcenotation` (mandatory, not empty)
    * `targetnotation` (mandatory, possibly empty)
    * `sourcepreflabel` (optional, possibly empty)
    * `targetepreflabel` (optional, possibly empty)
