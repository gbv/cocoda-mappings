<?php declare(strict_types=1);

include_once '../vendor/autoload.php';

$CC0 = new JSKOS\Concept([
    'uri' => 'http://creativecommons.org/publicdomain/zero/1.0/',
    'notation' => ['CC0']
]);
$VZG = new JSKOS\Concept([
    'prefLabel' => [
        'de' => 'Verbundzentrale des GBV',             
    ],
    'notation' => ['VZG'],
    'uri' => 'https://viaf.org/viaf/134648237'
]);

$concordances = [];
foreach (file('stats.csv', FILE_IGNORE_NEW_LINES) as $line) {
    list ($prop, $count) = explode(',', $line);

    $conc = new JSKOS\Concordance([
        'extent' => $count,
        'fromScheme' => [
            'uri' => 'http://bartoc.org/en/node/1940',
            'prefLabel' => [
                'en' => 'Wikidata'
            ]
        ],
        'publisher' => [ $VZG ],
        'license' => [ $CC0 ],
    ]);

    if (file_exists("$prop.csv")) {        
        $conc->modified = date('Y-m-d\TH:i:s',filemtime("$prop.csv"));
    }

    $mappings = [];
    foreach (['csv'=>'CSV', 'txt'=>'BEACON', 'ndjson'=>'JSKOS'] as $ext => $name) {        
        $file = "$prop.$ext";
        if (file_exists($file)) {
            $mappings[] = new JSKOS\Access([
                'download' => "https://coli-conc.gbv.de/concordances/wikidata/$file",
                'notation' => [$name]
            ]);
        }
    }
    $conc->mappings = $mappings;

    $concordances[$prop] = $conc;
}

foreach (file('properties.tsv', FILE_IGNORE_NEW_LINES) as $line) {
    $line = explode("\t", $line);
    $prop = preg_replace('/^.*(P[0-9]+)>$/','$1', $line[0]);
    if (isset($concordances[$prop])) {
        $concordances[$prop]->toScheme = [
            'uri' => "https://bartoc.org/en/node/".$line[2],
            'prefLabel' => [
                'en' => preg_replace('/^"|"@.+$/','',$line[3])
            ]
        ];
        $extent = preg_replace('/^"([0-9]+)".*/','$1',$line[5]);
        if ($extent) {
            $concordances[$prop]->toScheme->extent = $extent;
        }
        $concordances[$prop]->notation = [$prop];
        $concordances[$prop]->prefLabel = [
            'en' => preg_replace('/^"|"@.+$/','',$line[4])
        ];
/*        
        $concordances[$id]->WDPROPERTY = [
            'uri' => "http://www.wikidata.org/entity/$id",
            'prefLabel' => [ 
                'en' => preg_replace('/^"|"@.+$/','',$line[4])
            ],
            'notation' => [$id]
        ];
*/        
    }
}

usort($concordances, function($a, $b) {
    return $a->prefLabel['en'] <=> $b->prefLabel['en'];
});

$registry = new JSKOS\Registry([
    'prefLabel' => [
        'en' => 'Wikidata Mappings'
    ],
    'scopeNote' => [
        'en' => [
            'Mappings between Wikidata and other knowledge organization systems',
        ]
    ],
    'license' => [ $CC0 ],
    'publisher' => [ $VZG ],
    'concordances' => [
        [
            'set' => new JSKOS\Set($concordances)
        ]
    ]
]);

$file = 'wikidata-concordances.json';
file_put_contents($file, $registry->json());
