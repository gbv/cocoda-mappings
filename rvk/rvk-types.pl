#!/usr/bin/env perl
use v5.14;
use Catmandu -all;
use List::MoreUtils qw(any firstval natatime);

open my $personen,             '>:encoding(utf-8)', 'personen.csv';
open my $personen_unterklasse, '>:encoding(utf-8)', 'personen-unterklassen.csv';
open my $geografika,           '>:encoding(utf-8)', 'geografika.csv';
binmode *STDOUT, ':encoding(utf-8)';

my %geografika_namen = map { $_ => 1 }
  'Europa',
  'Nordeuropa', 'Südeuropa',
  'Asien', 'Asien, Orient, Östliche Welt', 'Asien (ohne GUS)',
  'Arabische Staaten',
  'Afrika',
  'Amerika', 'Nordamerika', 'Südamerika',
  'Arktiks',
  'Antarktis',
  'Australien',
  'Australien, Neuseeland, Ozeanien',
  ;

importer( 'MARC', type => 'XML' )->each(
    sub {
        # get MARC field 153
        my @rec = @{ shift->{record} };
        my ( undef, undef, undef, @f ) =
          @{ firstval( sub { $_->[0] eq '153' }, @rec ) };

        my ( $notation, $label, @broader );
        my $subfields = natatime 2, @f;
        while ( my ( $sf, $value ) = $subfields->() ) {
            if ( $sf eq 'a' ) {
                $notation = $value;
            }
            elsif ( $sf eq 'j' ) {
                $label = $value;
                $label =~ s/;/,/g;
            }
            elsif ( $sf eq 'h' ) {
                push @broader, $value;
            }
        }

        my @out;
        if (@broader) {
            if ( @broader[-1] =~ /Autoren [A-Z]+$/ ) {
                push @out, $personen;
            }
            elsif ( any { $_ =~ /Autoren [A-Z]+$/ } @broader ) {
                push @out, $personen_unterklasse;
            }

            if ( $geografika_namen{$_}
                or any { $geografika_namen{$_} } @broader )
            {
                push @out, $geografika;
            }
        }
        push @out, *STDOUT unless @out;

        say $_ "$notation;$label" for @out;
    }
);
