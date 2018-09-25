<?php
$BASE = '..';
include "$BASE/header.php";
?>

<p>We collect concordances and mappings in a public database.</p>

<div id=mappingsApp></div>

<?php
$html = (file_exists('../cocoda/mappings.html')
      ? file_get_contents('../cocoda/mappings.html')
      : file_get_contents('http://coli-conc.gbv.de/cocoda/mappings.html')) ?? '';
if (preg_match_all('!src=["\']?([^"\'>]+)!', $html, $match)) {
  foreach ($match[1] as $src) {
      echo "<script type='text/javascript' src='../cocoda/$src'></script>";
  }
}
if (preg_match_all('!link href=["\']?([^"\'> ]+)!', $html, $match)) {
  foreach ($match[1] as $src) {
    if (strpos($src, "bootstrap") === false) {
      echo "<link href='../cocoda/$src' rel='stylesheet'>";
    }
  }
}

include "$BASE/footer.php";
