#!/usr/bin/perl
use v5.14;

=head1 DESCRIPTION

Conversion script from RVK-XML dump to JSKOS.

Output file is newline-delimited JSON with one JSKOS Concept on each line.

=cut

use XML::LibXML;
use JSON;
use Data::Dumper;
use URI::Escape;

my $xmlfile   = 'rvko_2015_4.xml';    # input file
my $jskosfile = 'rvk_2015_4.json';    # output file

my $rvkuri   = 'http://bartoc.org/en/node/533';
my $urispace = 'http://uri.gbv.de/terminology/rvk/';

my $JSON   = JSON->new->utf8->canonical;
my $parser = XML::LibXML->new();
my $doc    = $parser->parse_file($xmlfile);
my $count  = 0;

open( my $out, '>', $jskosfile ) or die "Failed to open $jskosfile for writing";

sub conceptURI {
    my $notation = shift;
    $notation =~ s/\s//g;
    return $urispace . uri_escape($notation);
}

sub conceptType {
    my $notation = shift;

    # TODO: notation ranges such as "FX 403998 - FX 404305" may need to have another type
    my $type = ['http://www.w3.org/2004/02/skos/core#Concept'];

    return $type;
}

foreach my $node ( $doc->findnodes('//node') ) {
    my $notation = $node->getAttribute('notation');
    my %jskos    = (
        uri       => conceptURI($notation),
        type      => conceptType($notation),
        notation  => [ $notation ],
        preflabel => {
            de => $node->getAttribute('benennung'),
        },
        inScheme => {
            uri      => $rvkuri,
            notation => ['RVK'],
        }
    );
    my ($children) = $node->findnodes('./children');
    if ($children) {
        $jskos{'narrower'} = [];
        foreach my $child ( $children->findnodes('./node') ) {
            my ($childNotation) = $child->getAttribute('notation');
            my ($childLabel)    = $child->getAttribute('benennung');
            push @{$jskos{'narrower'}},
              {
                uri       => conceptURI($childNotation),
                type      => conceptType($childNotation),
                notation  => [ $childNotation ],
                prefLabel => { de => $childLabel }
              };
        }
    }

    my ($notes) = $node->findnodes('./content');
    my $bemerkung;
    if ($notes) {
        $bemerkung = $notes->getAttribute('bemerkung');
    }
    my $reg;
    my ($register) = $node->findnodes('./register');
    if ($register) {
        $reg = "Register:";
        foreach my $entry ( $node->findnodes('./register') ) {
            my $add = $entry->textContent;
            $add =~ s/\s+$//;
            $reg .= " $add.";

        }
    }
    if ( $notes || $register ) {
        $jskos{'scopeNote'}{'de'} = [];
        if ($notes) {
            push @{$jskos{'scopeNote'}{'de'}}, $bemerkung;
        }
        if ($register) {
            push @{$jskos{'scopeNote'}{'de'}}, $reg;
        }
    }

    my $parentC = $node->parentNode;
    if ( $parentC->nodeName eq 'children' ) {
        my $parent = $parentC->parentNode;
        $jskos{'broader'} = [];
        my $parentNotation   = $parent->getAttribute('notation');
        my $parentLabel      = $parent->getAttribute('benennung');
        push @{$jskos{'broader'}},
          { 
              uri       => conceptURI($parentNotation),
              type      => conceptType($parentNotation),
              notation  => $parentNotation, 
              prefLabel => { de => $parentLabel } 
          };
    }
    say $out $JSON->encode( \%jskos );
    $count++;
    if ( $count % 1000 == 0 ) {
        say "$count nodes processed.\t$notation";
    }
}

