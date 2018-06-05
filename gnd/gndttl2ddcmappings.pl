#!/usr/bin/env perl
use v5.14;

# extract DDC mappings from GND RDF/Turtle Dump the raw way
# usage: zcat GND.ttl.gz | perl gndttl2ddcmappings.pl > gnd_ddc_crisscross.csv

my @types = ('','related','broad','close','exact');
my $id;

say "sourcenotation;targetnotation;type";

while (<>) {
  if ($_ =~ qr{^<http://d-nb.info/gnd/([^>]+)}) {
    $id = $1;
  } elsif ($_ =~ qr{relatedDdcWithDegreeOfDeterminacy(\d)\s+<http://dewey.info/class/([^>]+)/>}) {
    say "$id;$2;".$types[$1] if $id;
  }
}
