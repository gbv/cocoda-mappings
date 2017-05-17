<?php 

include_once '../vendor/autoload.php';

$BASE = '../..';
$SOURCES = 'https://github.com/gbv/cocoda-mappings/tree/master/wikidata';
$LICENSE = '<img src="../cc-zero.svg">';

include '../header.php';

$registry = json_decode(file_get_contents('wikidata-concordances.json'));

$sum = 0;
$concordances = [];
foreach ($registry->concordances[0]->set as $conc) {
    $concordances[substr($conc->notation[0],1)] = new JSKOS\Concordance($conc);
    $sum += $conc->extent;
}

?>
<p><a href="../">🡐 more concordances</a></p>
<h3>Wikidata Mappings</h3>
<p>
  This directory contains mappings between Wikidata and other knowledge organization systems.
  The data is daily extracted from Wikidata and available as public domain 
  (<a href="https://creativecommons.org/publicdomain/zero/1.0/">CC Zero</a>).
  Information about this list can also be accessed as JSKOS Registry from
  <a href="wikidata-concordances.json">wikidata-concordances.json</a>.
</p>
<table class="table sortable table-hover">
  <thead>
    <tr>
      <th>ID</th>
      <th>Wikidata property</th>
      <th>KOS</th>
      <th>download</th>
      <th class='text-right'>mappings</th>
      <th>date</th>
    </tr>
  </thead>
  <tbody>
<?php foreach ($concordances as $conc) {
  $prop = $conc->notation[0];
  echo "<tr><td class='text-right'><a href='http://www.wikidata.org/entity/$prop'>$prop</a></td>";
  echo "<td><a href='http://www.wikidata.org/entity/$prop'>";
  echo htmlspecialchars($conc->prefLabel['en'] ?? '');
  echo "</a></td>";
  echo "<td><a href='{$conc->toScheme->uri}'>"
      .htmlspecialchars($conc->toScheme->prefLabel['en'] ?? '')."</a></td>";
  echo "<td>";
  foreach ($conc->mappings as $map) {
    if ($map->download) {
      echo "<a href='{$map->download}'>{$map->notation[0]}</a> ";
    }
  }
  echo "</td>";
  echo "<td class='text-right'>{$conc->extent}<br><img src='$prop.png'/></td>";
  echo "<td>".substr($conc->modified,0,10)."</td>";
  echo "</tr>";
} ?>
  </tbody>
  <tfoot>
    <tr>
      <td></td>
      <td class='text-right'>
        <?=count($concordances)?><br>
        <img src='kos.png'/>
      </td>
      <td></td>
      <td></td>
      <td class='text-right'><?=$sum?><br><img src='total.png'/></td>
      <th><a href="total.csv">total</a></th>
    </tr>
  </tfoot>
</table>
<?php
$query = rawurlencode(file_get_contents('properties.sparql'));
?>
<p>
  The list of properties is based on
  <a href="https://query.wikidata.org/#<?=$query?>">this SPARQL query</a> to
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
<p>
  Indirect mappings with Wikidata as linking hub can be harvested as well. See CSV file
  <a href="indirect.csv">indirect.csv</a> for current numbers with the authority files
  listed above. To actually download an indirect mapping use Wikidata BEACON or wdmapper
  (e.g. <code>wdmapper get P227 P2428</code> for GND-to-RePEc Short-ID).
</p>

<?php include '../footer.php'; ?>
