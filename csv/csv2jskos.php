<?php

// check script is called from command line as expected
if (php_sapi_name() != "cli") exit;
if (count($argv) < 2) {
    print "usage: php csv2jskos.php CSVFILE [OPTIONS]\n";
    exit;
}

// get source and target KOS from filename
$csvfile = $argv[1];
if (!preg_match('/^([a-z]+)_([a-z]+)_[a-z0-9_]+\.csv$/', $csvfile, $match)) {
    exit("CSV filename pattern must be source_target_etc.csv");
}

include '../kos.php';

$notation2uri = [
    'RVK' => function ($notation) {
        $notation = preg_replace('/\s*-\s*/', '-', $notation);
        $notation = preg_replace('/\s+/', '_', $notation);
        return "http://rvk.uni-regensburg.de/nt/$notation";
    },
    'BK' => function ($notation) {
        return "http://uri.gbv.de/terminology/bk/$notation";
    },
# TODO    
#    'DDC' => 
];

$fromScheme = strtoupper($match[1]);
$toScheme = strtoupper($match[2]);

foreach ([$fromScheme, $toScheme] as $notation) {
    if (!$notation2uri[$notation]) exit ("KOS $notation has no known URI forms");
}

// convert mappings in CSV to JSKOS
foreach (file($csvfile) as $line) {
    $mapping = explode(";",trim($line));
    if (!isset($header)) {
        $header = $mapping;
        if (!in_array('sourcenotation',$header)) {
            exit("missing field sourcenotation");
        }
    } else {
        $mapping = array_combine($header, $mapping);

        $jskos = [
            "from" => [
                "memberSet" => [
                    [ "uri" => $notation2uri[$fromScheme]($mapping['sourcenotation']) ]
                ]
            ],
            "to" => [
                "memberSet" => [
                    [ "uri" => $notation2uri[$toScheme]($mapping['targetnotation']) ]
                ]
            ],
            "fromScheme" => $kos[$fromScheme],
            "toScheme" => $kos[$toScheme],
        ];

        // TODO: `sourcepreflabel` (optional, possibly empty)
        // TODO: `targetepreflabel` (optional, possibly empty)

        echo json_encode($jskos, JSON_UNESCAPED_SLASHES) ."\n";
    }
}
