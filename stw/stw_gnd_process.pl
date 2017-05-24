#!/usr/bin/env perl
use v5.14;

# convert ZBW STW mappings (if skos:exactMatch) from NTriples to CSV
#
# $ wget http://zbw.eu/stw/version/9.0/download/stw_gnd_mapping.nt.zip
# $ zcat stw_gnd_mapping.nt.zip | ./stw_gnd_process.pl > stw_gnd_exact_zbw.csv

my $matchtype = '<http://www.w3.org/2004/02/skos/core#exactMatch>';
my $out='stw_gnd_zwb_exact.csv';

say "sourcenotation;targetnotation";
while (<>) {
    if ($_ =~ qr{^<http://zbw\.eu/stw/descriptor/([^>]+)> $matchtype <http://d-nb\.info/gnd/([^>]+)>}) {
        say "$1;$2";
    }
}
