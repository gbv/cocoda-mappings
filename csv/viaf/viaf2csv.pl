#!/usr/bin/env perl
use v5.14;
use Catmandu -all;

# known concept schemes
my $kos = importer( 'YAML', file => '../csv/kos.yaml' )->first;

# mapping of vocabulary codes in VIAF dump to vocabulary codes in kos.yaml
my %kosCode = (
    DNB => 'gnd',
    JPG => 'ulan'
);
my %csvFile;

# setup validation
foreach ( keys %kosCode ) {
    my $code = $kosCode{$_} or do {
        delete $kosCode{$_};
        next;
    };

    my $pattern   = $kos->{$code}{pattern};
    my $namespace = $kos->{$code}{namespace};

    $kos->{$code}{NOTATION} = qr{^$pattern$};
}

# convert VIAF dump to CSV files
while (<>) {
    chomp;

    $_ =~ qr{^http://viaf\.org/viaf/([1-9]\d(\d{0,7}|\d{17,20}))
       \t ([A-Z][A-Za-z0-9]+) ([@\|]) (.+)$ }x or do {
        say STDERR "! $_";
        next;
    };

    my ( $viaf, $scheme, $sep, $to ) = ( $1, $3, $4, $5 );

    # ignore all schemes not listed above with kosCode
    $scheme = $kosCode{$scheme} or next;

    my $csv = $csvFile{$scheme} //= exporter(
        'CSV',
        file   => "../csv/viaf_$scheme.csv",
        fields => [ 'fromNotation', 'toNotation' ]
    );

    if ( $sep eq '@' ) {
        my $ns = $kos->{$scheme}{namespace};
        if ( $ns ne substr $to, 0, length $ns ) {
            say STDERR "? $_";
            next;
        }
        $to = substr $to, length $ns;
    }

    if ( $to !~ $kos->{$scheme}{NOTATION} ) {
        say STDERR ": $_ $to\n" . $kos->{$scheme}{NOTATION};
        next;
    }

    $csv->add( { fromNotation => $viaf, toNotation => $to } );
}
