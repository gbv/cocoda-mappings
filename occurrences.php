<?php

// Utility functions to return JSON

function error(int $code, string $message) {
    $error = ['code' => $code, 'message' => $message];
	response($error, $code);
}

function response($data, int $code=200) {

    $json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

	$headers = [
    	'Access-Control-Allow-Origin' => '*',
        'Content-Type' => 'application/json; charset=UTF-8',
        'Content-Length' => strlen($json),
	];

	foreach ($headers as $header => $value) {
		header("$header: $value", false);
	}

	http_response_code($code);

	print $json;
	exit;
}

// Here we go...

require_once 'vendor/autoload.php';
require_once 'kos.php';

// lists of URIs separated by whitespace or '|'
#$inScheme = array_filter(preg_split('/[\s|]+/', $_GET['inScheme'] ?? ''));
$concepts = array_filter(preg_split('/[\s|]+/', $_GET['concepts'] ?? ''));

if (!count($concepts)) {
	error(400, 'missing query parameter concepts (space-separated list of URIs)');
}

if (count($concepts)>1) {
	error(400, 'occurrences with multiple concepts not supported yet');
}

$uri = $concepts[0];

foreach ($kos as $kosId => $scheme) {
	if (!$scheme['PATTERN']) continue;
	if (preg_match('/^'.$scheme['PATTERN'].'$/', $uri, $match)) {
		$id = $match[1];
		break;
	}
}

if (!isset($id)) {
	error(404, "concept URI not found: $uri");
}

if ($scheme['notation'][0] == 'BK') {
	$url = "http://sru.gbv.de/gvk?version=1.2&operation=searchRetrieve&query=pica.bkl=$id&maximumRecords=0&recordSchema=picaxml";
	$xml = file_get_contents($url);
	if (preg_match('/numberOfRecords>([0-9]+)</', $xml, $match)) {
		response([
			"database" => [ "uri" => "http://uri.gbv.de/database/gvk" ],
			"memberSet" => [ [ "uri" => $uri ] ],
			"count" => $match[1],
			"modified" => date("Y-m-d",time()),
			"url" => "https://gso.gbv.de/DB=2.1/CMD?ACT=SRCHA&IKT=1016&SRT=YOP&TRM=bkl+$id"
		]);
	} else {
		error(500, "failed to count occurrence");
	}
} else {
	error(404, "concept URIs not supported yet: ".$scheme['notation'][0]);
}

# WTF:
# Suche BKL 86.78 = 2291 Treffer
# Suche mit REL = 2946 Treffer

# für DDC: gvk.gbv.de/DB=2.1/NOMAT=T/CLK?IKT=8562&TRM=$id
