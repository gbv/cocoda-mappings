This directory contains concordances and mappings from different sources given as or converted to CSV files.

The base format are CSV files with the following conventions:

* semicolon (`;`) is used as field separator
* field values can be quotes with `"` if needed
* file names have form `SOURCE_TARGET_TEXT.csv` where
    * `SOURCE` is a lowercase, mnemonic id of the source KOS
    * `TARGET` is a lowercase, mnemonic id of the target KOS
    * `TEXT` is a brief additional description of the concordance
* supported fields are
    * `fromNotation` (mandatory, not empty)
    * `toNotation` (mandatory, possibly empty)
    * `sourcepreflabel` (optional, ignored anyway)
    * `targetepreflabel` (optional, ignored anyway)
    * `type` (optional mapping type)

Additional metadata is included in:

* `concordances.yaml` contains a list of concordances.
  Concordance keys must match CSV file names.
  
* `kos.yaml` contains a list of KOS with notation and BARTOC URI

See `Makefile` for details and references to conversion scripts written in Perl with Catmandu framework.

[![Build Status](https://travis-ci.org/gbv/cocoda-mappings.svg?branch=master)](https://travis-ci.org/gbv/cocoda-mappings)
