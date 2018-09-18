#!/usr/bin/env perl
use v5.14;

# extract close match mappings from GND to LCSH
# RAMEAU is not processed yet, as its URIs are not clear.

sub gnd {
    return if $_[0] !~ qr{^<(http://d-nb\.info/gnd/([0-9]+-?[0-9X]))>$};
    return $2;
}

sub lcsh {
    return if $_[0] !~ qr{^<(
            http://id\.loc\.gov/authorities/subjects/
            ((n|nb|nr|no|ns|sh)([4-9][0-9]|00|20[0-1][0-9])[0-9]{6}))}x;
    return $2;
}

say "sourcenotation;targetnotation;type";

while (<>) {
    my ( $s, $p, $o ) = split ' ';

    next if $p !~ '<http://www.w3.org/2004/02/skos/core#([a-z]+)Match>';
    my $type = $1;

    if ( my $gnd = gnd($s) ) {
        if ( my $lcsh = lcsh($o) ) {
            say "$gnd;$lcsh;$type";
        }
    }
}
