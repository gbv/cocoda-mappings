#!/usr/bin/env perl
use v5.14;
use Catmandu -all;

my $json = exporter( 'JSON', line_delimited => 1, canonical => 1 );

my $concordances = importer( 'YAML', file => 'concordances.yaml' )->next;
my $kos          = importer( 'YAML', file => '../kos.yaml' )->next;

while ( my ( $id, $conc ) = each %$concordances ) {
    my $file = $conc->{file} // "$id.csv";
    -f $file or die "missing file $file";

    my $extent = `wc -l "$file"` - 1;
    warn "$file has $extent mappings, expected $_\n"
      for grep { $_ ne $extent } $conc->{count} // $extent;

    $id =~ /^([^_]+)_([^_]+)/ or die "$id pattern not recognized";
    die "unknown scheme: $_\n" for grep { !$kos->{$_} } ( $1, $2 );

    my %jskos = (
        '@context' => 'https://gbv.github.io/jskos/context.json',
        type       => ['http://rdfs.org/ns/void#Linkset'],
        uri        => "http://coli-conc.gbv.de/concordances/$id",
        notation   => [$id],
        extent     => "$extent",
        fromScheme => $kos->{$1},
        toScheme   => $kos->{$2},
    );

    $jskos{created} = "$conc->{created}" if $conc->{created};

    if ( my $creator = $conc->{creator} ) {
        $jskos{creator} = [
            ref $creator
            ? $creator
            : { prefLabel => { de => $creator } }
        ];
    }
    else {
        warn "missing creator for $file\n";
    }

    if ( $conc->{contributor} ) {
        $jskos{contributor} = $conc->{contributor};
    }

    $jskos{scopeNote} = { de => [ $conc->{about} ] } if $conc->{about};

    $json->add( \%jskos );
}
