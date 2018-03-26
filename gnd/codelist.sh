#!/bin/bash

curl http://id.loc.gov/vocabulary/identifiers.madsrdf.nt |
    \grep 'hasMADSSchemeMember>'
