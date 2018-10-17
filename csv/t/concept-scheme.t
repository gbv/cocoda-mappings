use Test::More;
use v5.14;

use GBV::ConceptScheme; 

my $kos = GBV::ConceptScheme->new({
    uri       => 'http://example.org/',
    namespace => 'http://example.org/',
    pattern   => '[0-9]+'
});

my $concept = { 
    uri => 'http://example.org/0',
    notation => ['0']
};

is_deeply $concept, $kos->notation2concept('0'), 'notation2concept';
ok !$kos->notation2concept('a');

is_deeply $concept, $kos->uri2concept('http://example.org/0'), 'uri2concept';
ok !$kos->uri2concept('http://example.org/a');

done_testing;
