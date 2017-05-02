Konvertiert eine CSV-Datei mit Mappings in entsprechendes JSON-Format

use strict;
use Catmandu::Importer::CSV;
use Catmandu::Exporter::JSON;
use Time::Piece;

my ($file) = @ARGV;
my $creator   = "VZG";
my $timestamp = gmtime()->datetime;
my $from_column  = "ddc";
my $to_column    = "rvk";
my $label_column = "label";
my $label_language = "de";

my $importer = Catmandu::Importer::CSV->new(file => $file);
my $exporter = Catmandu::Exporter::JSON->new;

my %mappings;

$importer->each(sub {
    my ($row) = @_;

    my $from = $row->{ $from_column };
    return if !defined $from or $from eq "";

    my $to = $row->{ $to_column };
    return if !defined $to or $to eq "";

    my $label = $row->{ $label_column };

    push @{ $mappings{$from} }, {
        notation => $to,
        (defined $label ? ( label => { $label_language => $label } ) : ()),
    };
});

while (my ($from, $to) = each %mappings) {
    my $json = {
        from      => { notation => $from },
        to        => $to,
        timestamp => $timestamp,
        creator   => $creator
    };
    $exporter->add( $json );
}
