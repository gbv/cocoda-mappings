package GBV::ConceptScheme;
use v5.14;

use List::Util qw(any);

sub new {
    my ( $class, $scheme ) = @_;

    # derive template from namespace, if available
    if ( my $namespace = $scheme->{namespace} ) {
        $scheme->{template} ||=
          $namespace . '(' . ( $scheme->{pattern} || '.*' ) . ')';
    }

    bless $scheme, $class;
}

sub notation2uri {
    my ( $self, $notation ) = @_;
    return if $notation eq '';

    my $template = $self->{template} // return;

    # See <https://github.com/gbv/jskos/issues/69>
    if ( my $pattern = $self->{pattern} ) {
        return if $notation !~ qr{^$pattern$};
    }
    my $uri = $template;
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

    my $template = $self->{template} // return;
    return unless $uri =~ qr{$template};

    my $notation = $1 // return;

    # special case for cleaning up RVK notations
    if ( $self->{uri} eq 'http://bartoc.org/en/node/533' ) {
        $notation =~ s/([^ ])-([^ ])/$1 - $2/g;
    }

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
