package GBV::ConceptScheme;
use v5.14;

use List::Util qw(any);

sub new {
    my ( $class, $scheme ) = @_;

    # derive uriPattern from namespace, if available
    if ( my $namespace = $scheme->{namespace} ) {
        $scheme->{uriPattern} ||=
          $namespace . '(' . ( $scheme->{notationPattern} || '.*' ) . ')';
    }

    bless $scheme, $class;
}

sub notation2uri {
    my ( $self, $notation ) = @_;
    return if $notation eq '';

    my $uriPattern = $self->{uriPattern} // return;

    if ( my $notationPattern = $self->{notationPattern} ) {
        if ( $notation !~ qr{^$notationPattern$} ) {
            return;
        }
    }

    my $uri = $uriPattern;
    $notation =~ s/ /%20/g;
    $uri =~ s/\([^)]*\)/$notation/;
    return $uri;
}

sub notation2concept {
    my ( $self, $notation, @fields ) = @_;

    if ( my $uri = $self->notation2uri($notation) ) {
        return $self->concept( $uri, $notation, @fields );
    }
}

sub uri2concept {
    my ( $self, $uri, @fields ) = @_;

    my $uriPattern = $self->{uriPattern} // return;
    return unless $uri =~ qr{$uriPattern};

    my $notation = $1 // return;

    return $self->concept( $uri, $notation, @fields );
}

sub concept {
    my ( $self, $uri, $notation, @fields ) = @_;
    my %concept = (
        uri      => $uri,
        notation => [$notation],
    );
    $concept{inScheme} = [ { uri => $self->{uri} } ]
      if any { $_ eq 'inScheme' };
    return \%concept;
}

sub minimal {
    my $self = shift;
    return { map { ( $_ => $self->{$_} ) if $self->{$_} } qw(uri notation) };
}

1;
