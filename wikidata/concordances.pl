#!/usr/bin/env perl
use v5.14;
use JSON::PP;
use POSIX qw(strftime);
use autodie;

my $CC0 = {
  uri => 'http://creativecommons.org/publicdomain/zero/1.0/',
  notation => ['CC0']
};

my $VZG = {
  prefLabel => { de => 'Verbundzentrale des GBV' },
  notation => ['VZG'],
  uri => 'https://viaf.org/viaf/134648237'
};

my %concordances;

open my $fh, 'stats.csv';
while (my $line = <$fh>) {
  chomp $line;
  my ($prop, $count) = split ',', $line;

  my %conc = (
    extend => $count,
    fromScheme => {
      uri => 'http://bartoc.org/en/node/1940',
      prefLabel => { en => 'Wikidata' },
      publisher => [ $VZG ],
      license => [ $CC0 ],
    }
  );

  if (-r "$prop.csv") {        
    $conc{modified} = strftime('%Y-%m-%dT%H:%M:%S', gmtime((stat("$prop.csv"))[9]));
  }

  my @mappings;
  my %formats = ( csv => 'CSV', txt => 'BEACON', ndjson => 'JSKOS' );
  while (my ($ext, $name) = each %formats) {
    my $file = "$prop.$ext";
    if (-e $file) {
      push @mappings, { # JSKOS access
        download => "https://coli-conc.gbv.de/concordances/wikidata/$file",
        notation => [$name]
      };
    } 
  }

  $conc{mappings} = \@mappings;

  $concordances{$prop} = \%conc;
}

open my $fh, 'properties.tsv';
while (my $line = <$fh>) {
  chomp $line;
  my @fields = split ',', $line;
  
  my $prop = $fields[0] =~ s/^.*(P[0-9]+)>$/$1/r;
  $concordances{$prop} or next;

  $concordances{$prop}{toScheme} = {
    uri => "https://bartoc.org/en/node/".$fields[2],
    prefLabel => {
      en => ($fields[3] =~ s/^"|"@.+$//r)
    }
  };

  $concordances{$prop}{toScheme}{extent} = $1
    if $fields[5] =~ /^"([0-9]+)".*/;
    
  $concordances{$prop}{notation} = [$prop];

  my $name = $fields[4] =~ s/^"|"@.+$//r;

  $concordances{$prop}{prefLabel} = { en => $name };

  #  $concordances{$id}{WDPROPERTY} = {
  #  uri => "http://www.wikidata.org/entity/$id",
  #  prefLabel => { en => $name },
  #  notation => [$id] 
  # };
}

# usort($concordances, function($a, $b) {
#    return $a->prefLabel['en'] <=> $b->prefLabel['en'];
# });

my $registry = {
    prefLabel => { en => 'Wikidata Mappings' },
    scopeNote => {
      en => [ 'Mappings between Wikidata and other knowledge organization systems' ]
    },
    license => [ $CC0 ],
    publisher => [ $VZG ],
    concordances => [ (values %concordances) ],
};

open my $fh, '>', 'wikidata-concordances.json';
say $fh JSON::PP->new->canonical->encode($registry);

