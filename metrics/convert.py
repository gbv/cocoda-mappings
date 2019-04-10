#!/usr/bin/env python3

import requests
import urllib
import re

pre="https://coli-conc.gbv.de/api//mappings?partOf=http://coli-conc.gbv.de/concordances/"
post="&download=ndjson"

with open("mappingnames.txt", "r") as ins:
    for line in ins:
        line = line.rstrip("\n")
        join = pre + line + post
        print(join)
        r = requests.get(join)       
        open(line + ".ndjson", 'wb').write(r.content)
        
    
