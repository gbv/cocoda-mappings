<?php

foreach (file(dirname(__FILE__).'/csv/kos.tsv') as $line) {
    list ($notation, $uri, $pattern) = explode("\t",trim($line));
    if (!isset($kos)) { 
        $kos = [];
        continue; 
    }
    $notation = strtoupper($notation);
    $kos[$notation] = [
        'notation' => [$notation],
        'uri' => $uri,
        'PATTERN' => $pattern
    ];
}


