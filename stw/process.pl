#!/usr/bin/env perl
use v5.14;

# convert ZBW STW mappings from NTriples to CSV
#
# $ wget http://zbw.eu/stw/version/9.0/download/stw_gnd_mapping.nt.zip
# $ zcat stw_gnd_mapping.nt.zip | ./process.pl > stw_gnd_zbw.csv

say "fromNotation;toNotation;type";
while (<>) {
    say "$1;$3;$2" if $_ =~ qr{^
        <http://zbw\.eu/stw/descriptor/([^>]+)>\s+
        <http://www\.w3\.org/2004/02/skos/core\#(broad|narrow|exact|close|related)Match>\s+
        <https://d-nb\.info/gnd/([^>]+)>
    }x;
}
