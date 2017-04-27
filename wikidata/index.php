<?php 

$BASE = '../..';
$SOURCES = 'https://github.com/gbv/cocoda-mappings/tree/master/wikidata';
$LICENSE = '<img src="../cc-zero.svg">';

include '../header.php';

# TODO: use JSKOS concordance object instead
$mappings = [];
$sum=0;
foreach (file('stats.csv', FILE_IGNORE_NEW_LINES) as $line) {
   @list ($count, $p) = explode(',', $line);
   $mappings[substr($p,1)] = [
     'count' => $count,
     'mtime' => filemtime("$p.csv"),
     'id' => $p
   ];
   $sum += $count;
}
ksort($mappings);

foreach (file('properties.tsv', FILE_IGNORE_NEW_LINES) as $line) {
   $line = explode("\t", $line);
   $n = substr($line[0],1);
   if (isset($mappings[$n])) {
     $mappings[$n]['bartoc'] = "https://bartoc.org/en/node/".$line[2];
     $mappings[$n]['kos'] = preg_replace('/^"|"@.+$/','',$line[3]);
     $mappings[$n]['label'] = preg_replace('/^"|"@.+$/','',$line[4]);
  }
}

?>
<h3>Wikidata Mappings</h3>
<p>
  This directory contains mappings between Wikidata and other knowledge organization systems.
  The data is regularly extracted from Wikidata and available as public domain 
  (<a href="https://creativecommons.org/publicdomain/zero/1.0/">CC Zero</a>).
</p>
<table class="table">
  <thead>
    <tr>
      <th>Wikidata property</th>
      <th>KOS</th>
      <th>download</th>
      <th class='text-right'>count</th>
      <th>date</th>
    </tr>
  </thead>
  <tbody>
<?php foreach ($mappings as $m) {
  echo "<tr><td>";
  echo "<a href='http://www.wikidata.org/entity/{$m['id']}'>";
  echo htmlspecialchars($m['label'] ?? '');
  echo "</a></td>";
  echo "<td><a href='{$m['bartoc']}'>".htmlspecialchars($m['kos'] ?? '')."</a></td>";
  echo "<td>";
  foreach (['csv'=>'CSV', 'txt'=>'BEACON', 'ndjson'=>'JSKOS'] as $ext => $name) {
    $file = $m['id'].".$ext";
    if (file_exists($file)) {
      echo "<a href='$file'>$name</a> ";
    }
  }
  echo "</td>";

  echo "<td class='text-right'>{$m['count']}</td>";
  echo "<td>".date('Y-m-d H:i',$m['mtime'])."</td>";
  echo "</td></tr>";
} ?>
  </tbody>
  <tfoot>
    <tr>
      <td class='text-center'><?=count($mappings)?></td>
      <td></td>
      <td></td>
      <td class='text-right'><?=$sum?></td>
      <th>total</th>
    </tr>
  </tfoot>
</table>
<p>
  The list of properties is based on <a href="properties.sparql">this SPARQL query</a> to
  include all mapping properties with corresponding KOS registered in 
  <a href="https://bartoc.org/">BARTOC</a>. Mappings are extracted and converted with
  the command line tool <a href="https://wdmapper.readthedocs.io/">wdmapper</a>.
</p>
<p>
  See also the <a href="https://tools.wmflabs.org/wikidata-todo/beacon.php">Wikidata BEACON</a>
  tool to directly download selected mappings and
  <a href="https://tools.wmflabs.org/mix-n-match/">Mix'n'match</a> to contribute adding mappings
  to Wikidata.
</p>

<?php include '../footer.php'; ?>
