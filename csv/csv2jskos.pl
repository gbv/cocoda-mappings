#!/usr/bin/env perl
use v5.14;
use Catmandu -all;

binmode *STDERR, ':encoding(UTF-8)';

my ($csvfile) = @ARGV;

# known concept schemes
my $kos = importer( 'YAML', file => 'kos.yaml' )->first;

# get source and target KOS from filename
$csvfile =~ /^([a-z]+)[_-]([a-z]+)[_-][a-z0-9_-]+\.csv$/
  or die "CSV filename pattern must be source_target_text.csv\n";

my ( $fromScheme, $toScheme ) = ( $1, $2 );

my %notation2uri = (    # TODO: move to kos.yaml
    lcsh => sub {
        return "http://id.loc.gov/authorities/subjects/$_[0]";
    },
    rvk => sub {
        my $notation = shift;
        $notation =~ s/\s*-\s*/-/;
        $notation =~ s/\s+/_/;    # TODO: use %20 instead
        return "http://rvk.uni-regensburg.de/nt/$notation";
    },
    bk => sub {
        return "http://uri.gbv.de/terminology/bk/$_[0]"
          if $_[0] =~ /^(0|1-2|3-4|5|7-8|[0-9]{2}(\.[0-9]{2})?)$/;
    },
    ddc => sub {
        my $regex = join '|',
          '[0-9][0-9]?',
          '[0-9]{3}(-[0-9]{3})?',
          '[0-9]{3}\.[0-9]+(-[0-9]{3}\.[0-9]+)?',
          '[1-9][A-Z]?--[0-9]+',
          '[1-9][A-Z]?--[0-9]+(-[1-9][A-Z]?--[0-9]+)?';
        return "http://dewey.info/class/$_[0]/e23/" if $_[0] =~ /^($regex)$/;
    },
    gnd => sub {
        return "http://d-nb.info/gnd/$_[0]" if $_[0] =~ /^[0-9X-]+$/;
    },
    stw => sub {
        return "http://zbw.eu/stw/descriptor/$_[0]"
          if $_[0] =~ /^[0-9]+-[0-9]$/;
    }
);

foreach ( ( $fromScheme, $toScheme ) ) {
    die "KOS $_ has no known URI forms!\n" unless $notation2uri{$_};
    die "KOS $_ not defined!\n" unless $kos->{$_};
}

sub notation2concept {
    my ( $scheme, $notation ) = @_;
    return if $notation eq '';

    if ( $notation2uri{$scheme} ) {
        if ( my $uri = $notation2uri{$scheme}->($notation) ) {
            return [ { uri => $uri, notation => [$notation] } ];
        }
    }
}

# convert mappings in CSV to JSKOS
my $exporter = exporter( 'JSON', line_delimited => 1 );
my $sourcenotation = '';
importer( 'CSV', file => $csvfile, sep_char => ';', allow_loose_quotes => 1 )
  ->each(
    sub {
        my $m = shift;
        return unless defined $m->{sourcenotation};

        if ( $m->{sourcenotation} ne '' ) {
            $sourcenotation = $m->{sourcenotation};
            $sourcenotation =~ s/^\s+|\s+$//g;
        }
        my ($targetnotation) = $m->{targetnotation};
        $targetnotation =~ s/^\s+|\s+$//g;

        my ($type) = $m->{type};
        if ( $type !~ /^(|close|exact|broad|narrow|related)$/ ) {
            say STDERR "$sourcenotation;$targetnotation;$type";
            return;
        }

        my $fromSet = notation2concept( $fromScheme, $sourcenotation );
        my $toSet   = notation2concept( $toScheme,   $targetnotation );

        if ( $fromSet && $toSet ) {
            my %jskos = (
                from       => { memberSet => $fromSet },
                to         => { memberSet => $toSet },
                fromScheme => $kos->{$fromScheme},
                toScheme   => $kos->{$toScheme},
            );

            # TODO: `sourcepreflabel` (optional, possibly empty)
            # TODO: `targetepreflabel` (optional, possibly empty)
            $jskos{type} = "http://www.w3.org/2004/02/skos/core#${type}Match"
              if $m->{type};

            $exporter->add( \%jskos );
        }
        elsif ( $sourcenotation || $targetnotation ) {
            say STDERR "$sourcenotation;$targetnotation;$type";
        }
    }
  );
