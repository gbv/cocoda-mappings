<?php

require_once('../vendor/autoload.php');
include_once '../kos.php';

use JSKOS\Concordance;

foreach (file('concordances.tsv') as $line) {    
    list ($from,$to,$scopeNote,$count,$creator,$file) = explode("\t",trim($line));
    if (!file_exists($file)) {
        error_log("Missing file $file");
        continue;
    }
    $concordance = new Concordance([
        'fromScheme' => $kos[$from],
        'toScheme'   => $kos[$to],
        'scopeNote'  => ['de' => [ $scopeNote ]],
        'creator'    => [ 
            [ 'prefLabel' => [ 'de' => $creator ] ],
        ],
        'identifier' => [preg_replace('/\.csv$/','',$file)],
        'extent' => ''.(exec("wc -l $file")-1)
    ]);

    print "$concordance\n";
}
