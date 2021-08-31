#!/usr/bin/env perl
use v5.14;
use Catmandu -all;
use lib './lib';
use GBV::ConceptScheme;

binmode *STDERR, ':encoding(UTF-8)';

my ($csvfile) = @ARGV;

# known concept schemes
my $kos = importer( 'YAML', file => '../kos-registry/kos.yaml' )->first;
$kos->{$_} = GBV::ConceptScheme->new( $kos->{$_} ) for keys %$kos;

# get source and target KOS from filename
$csvfile =~ /^([a-z]+)[_-]([a-z]+)([_-][a-z0-9_-]+)?\.csv$/
  or die "CSV filename pattern must be source_target[_text].csv\n";

my ( $fromScheme, $toScheme ) =
  map { $kos->{$_} || die "KOS $_ not defined!\n" } ( $1, $2 );

# convert mappings in CSV to JSKOS
my $exporter = exporter( 'JSON', line_delimited => 1 );
my $fromNotation = '';
importer( 'CSV', file => $csvfile, sep_char => ';', allow_loose_quotes => 1 )
  ->each(
    sub {
        my $m = shift;
        return unless defined $m->{fromNotation};

        if ( $m->{fromNotation} ne '' ) {
            $fromNotation = $m->{fromNotation};
            $fromNotation =~ s/^\s+|\s+$//g;
        }
        my ($toNotation) = $m->{toNotation};
        $toNotation =~ s/^\s+|\s+$//g;

        my ($type) = $m->{type};
        if ( $type !~ /^(|close|exact|broad|narrow|related)$/ ) {
            say STDERR "$fromNotation;$toNotation;$type";
            return;
        }

        my $fromConcept = $fromScheme->notation2concept($fromNotation);
        my $toConcept   = $toScheme->notation2concept($toNotation);

        my $fromSet = defined $fromConcept ? [$fromConcept] : [];
        my $toSet   = defined $toConcept   ? [$toConcept]   : [];

        if ( @$fromSet && ( @$toSet || $toNotation eq '' ) ) {
            my %jskos = (
                from       => { memberSet => $fromSet },
                to         => { memberSet => $toSet },
                fromScheme => $fromScheme->minimal,
                toScheme   => $toScheme->minimal,
            );

            $jskos{type} = ["http://www.w3.org/2004/02/skos/core#${type}Match"]
              if $m->{type};

            $exporter->add( \%jskos );
        }
        elsif ( $fromNotation || $toNotation ) {
            say STDERR "$fromNotation;$toNotation;$type";
        }
    }
  );
