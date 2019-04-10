# cocoda-concordances
> Scripts for downloading all Cocoda-Concordances as NDJSON-Files

## Usage
* First the script `download.sh` has to be executed, it downloads the concordances as `concordances.ndjson`. The notations will be extracted from `concordances.ndjson` and a new file `mappingnames.txt` which is essential for the main-script will be created.

* The main-script `convert.py` builds a valid URL with the mappingnames and downloads the content into files.

### Examples 
~~~
./download.sh

./convert.py
~~~