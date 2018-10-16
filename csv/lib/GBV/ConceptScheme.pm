package GBV::ConceptScheme;
use v5.14;

sub new {
    my ($class, $scheme) = @_;
    
    # derive template from namespace, if available
    if ( my $namespace = $scheme->{namespace} ) {
        $scheme->{template} ||= $namespace . '()' if $namespace;
    }

    bless $scheme, $class;
}

sub notation2uri {
    my ( $self, $notation ) = @_;
    return if $notation eq '';

    # TODO: remove once RVK URIs have been switched
    if ( $self->{uri} eq 'http://bartoc.org/en/node/533' ) {
        return
          if $notation !~
/^[A-Z]([A-Z]( [0-9]+(\.[0-9]+)?)?)?( - [A-Z]([A-Z]( [0-9]+(\.[0-9]+)?)?))?$/;
        $notation =~ s/\s*-\s*/-/;
        $notation =~ s/\s+/_/g;    # TODO: use %20 instead
        return "http://rvk.uni-regensburg.de/nt/$notation";
    }

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
    my ( $self, $notation ) = @_;

    if ( my $uri = $self->notation2uri($notation) ) {
        return { uri => $uri, notation => [$notation] };
    }
}

sub minimal {
    my $self = shift;    
    return {
        map { ( $_ => $self->{$_} ) if $self->{$_} } 
        qw(uri notation)
    };
}

1;
