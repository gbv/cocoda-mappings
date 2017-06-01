<?php

include '../vendor/autoload.php';

use Davaxi\Sparkline;

$data = [];

# load and store number of mappings per concordance
foreach (file('statlog.csv') as $line) {
    list($date,$prop,$count) = explode(',',trim($line));
    $data[$prop][$date] = $count;
}

# count total number of mappings
foreach (file('total.csv') as $line) {
    list($date,$count) = explode(',',trim($line));
    $data['total'][$date] = log($count);
}

# count number of KOS
foreach ($data as $prop => $counts) {
    foreach ($counts as $date => $value) {
        @$data['kos'][$date]++;
    }
}

# create PNG sparklines
foreach ($data as $prop => $counts) {
    $sparkline = new Sparkline();
    $min = min($counts);
    $max = max($counts);
    if ($min == $max and $min > 0) {
        $min = 0;
    }
    $counts = array_map(
        function($count) use ($min) { return $count-$min; }, 
        $counts
    );
    $width = min(2*count($counts),80);
    $sparkline->setWidth($width);
    $sparkline->setData($counts);

    if (!is_dir($prop)) {
        mkdir($prop);
    }
    $sparkline->save("$prop/growth.png");
    $sparkline->destroy();
}
