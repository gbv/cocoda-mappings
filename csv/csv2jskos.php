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
    exit("CSV filename pattern must be source_target_text.csv");
}

$dir = dirname(__FILE__);
include_once "$dir/../vendor/autoload.php";

use Symfony\Component\Yaml\Yaml;
$kos = Yaml::parseFile('kos.yaml');

$notation2uri = [
    'RVK' => function ($notation) {
        $notation = preg_replace('/\s*-\s*/', '-', $notation);
        $notation = preg_replace('/\s+/', '_', $notation);
        return "http://rvk.uni-regensburg.de/nt/$notation";
    },
    'BK' => function ($notation) {
        return "http://uri.gbv.de/terminology/bk/$notation";
    },
    'DDC' => function ($notation) {
        if (preg_match('/^([0-9]{3}(\.[0-9]+)?|[1-9][A-Z]?--[0-9]+)$/', $notation)) {            
            return "http://dewey.info/class/$notation/e23/";
        }
    },
    'GND' => function ($notation) {
        if (preg_match('/^[0-9X-]+$/', $notation)) {            
            return "http://d-nb.info/gnd/$notation";
        }
    },
    'STW' => function ($notation) {
        if (preg_match('/^[0-9]+-[0-9]$/', $notation)) {            
            return "http://zbw.eu/stw/descriptor/$notation";
        }
    }
];

function notation2concept($scheme, $notation) {
    global $notation2uri;

    $notation = trim($notation);
    if ($notation === '') return [ ];

    $f = $notation2uri[$scheme];
    if ($f) $uri = $f($notation);
    if (isset($uri)) {
        return [ [ 'uri' => $uri, 'notation' => [$notation] ] ];
    } else {
        error_log("malformed $scheme notation: $notation");
        return [ ];
    }
}

$fromScheme = strtoupper($match[1]);
$toScheme = strtoupper($match[2]);

foreach ([$fromScheme, $toScheme] as $notation) {
    if (!$notation2uri[$notation]) exit ("KOS $notation has no known URI forms!");
    if (!$kos[strtolower($notation)]) exit ("KOS $notation not defined!");
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
        $mapping = @array_combine($header, $mapping);

        $fromSet = notation2concept($fromScheme, $mapping['sourcenotation']);
        $toSet = notation2concept($toScheme, $mapping['targetnotation']);

        if ($fromSet && $toSet) {
            $jskos = [
                "from" => [ 'memberSet' => $fromSet ],
                "to" => [ "memberSet" => $toSet ],
                "fromScheme" => $kos[strtolower($fromScheme)],
                "toScheme" => $kos[strtolower($toScheme)],
            ];

            // TODO: `sourcepreflabel` (optional, possibly empty)
            // TODO: `targetepreflabel` (optional, possibly empty)
            if ($mapping['type'] ?? null) {
                $jskos['type'] = 'http://www.w3.org/2004/02/skos/core#'.$mapping['type'].'Match';
            }

            echo json_encode($jskos, JSON_UNESCAPED_SLASHES) ."\n";
        }
    }
}
