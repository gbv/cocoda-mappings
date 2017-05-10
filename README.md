This repository contains concordances between knowledge organization systems
(KOS) and scripts to harvest and convert these concordances. 

This work is part of [project coli-conc](https://coli-conc.gbv.de/).

* the base directory contains PHP scripts to show 
  concordances at <https://coli-conc.gbv.de/concordances/>

* directory `wikidata` contains scripts to harvest mappings from Wikidata
* directory `csv` contains concordances and mappings from different sources in CSV format
* directory `zbw` contains scripts to convert mappings provided by ZBW

See file `README.md` in each particular directory for futher documentation.

# REQUIREMENTS

* wdmapper
* PHP >= 7.0 with ext-gd enabled

~~~bash
$ sudo apt-get install php-gd
$ composer install
~~~~
