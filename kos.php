<?php

$dir = dirname(__FILE__);
include_once "$dir/vendor/autoload.php";

use Symfony\Component\Yaml\Yaml;
$kos = Yaml::parseFile("$dir/csv/kos.yaml");
