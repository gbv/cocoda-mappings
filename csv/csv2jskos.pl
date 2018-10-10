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

my %notation2uri = (    # TODO: remove once RVK URIs have been switched
    rvk => sub {
        my $notation = shift;
        $notation =~ s/\s*-\s*/-/;
        $notation =~ s/\s+/_/g;    # TODO: use %20 instead
        return "http://rvk.uni-regensburg.de/nt/$notation";
    }
);

# See <https://github.com/gbv/jskos/issues/69>
foreach ( keys %$kos ) {
    my $namespace = $kos->{$_}{namespace};
    my $template  = $kos->{$_}{template};
    $template = $namespace . '()' if !$template && $namespace;

    my $pattern = $kos->{$_}{pattern};
    $pattern = qr{^$pattern$} if $pattern;

    $notation2uri{$_} //= sub {
        if ($template) {
            my $id = shift;
            return if $pattern && $id !~ $pattern;
            my $uri = $template;
            $id =~ s/ /%20/g;
            $uri =~ s/\([^)]*\)/$id/;
            return $uri;
        }
    };
}

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

        my $fromSet = notation2concept( $fromScheme, $fromNotation );
        my $toSet   = notation2concept( $toScheme,   $toNotation );

        if ( $fromSet && $toSet ) {
            my %jskos = (
                from       => { memberSet => $fromSet },
                to         => { memberSet => $toSet },
                fromScheme => $kos->{$fromScheme},
                toScheme   => $kos->{$toScheme},
            );

            # TODO: `sourcepreflabel` (optional, possibly empty)
            # TODO: `targetepreflabel` (optional, possibly empty)
            $jskos{type} = ["http://www.w3.org/2004/02/skos/core#${type}Match"]
              if $m->{type};

            $exporter->add( \%jskos );
        }
        elsif ( $fromNotation || $toNotation ) {
            say STDERR "$fromNotation;$toNotation;$type";
        }
    }
  );
