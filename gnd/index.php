<?php
$BASE = '../..';
$TITLE = 'GND';
include "$BASE/header.php";
?>

<p>The <b>Integrated Authority File (GND)</b> is an authority file for Persons,
Corporate bodies, Conferences and Events, Geographic Information, Topics and
Works. It is operated cooperatively mostly by German libraries. Its content can
be used under <a href="http://creativecommons.org/publicdomain/zero/1.0/">CC
1.0</a> in multiple formats.</p>

<p>GND is being mapped to several other knowledge organization systems.</p>

<h3>Mappings stored in GND</h3>

<?php
$mappings = [];
foreach (file('count-gnd-mappings.csv') as $line) {
    list($date, $code, $count) = explode(',',rtrim($line));
    if ($count) {
        $mappings[$code] = ['date' => $date, count => $count];
    }
}

?>
<table class="table sortable table-hover tablesorter tablesorter-gbv">
  <thead>
    <tr>
      <th class="text-right">Mappings</th>
      <th>KOS</th>
      <th>Date</th>
    </tr>
  </thead>
  <tbody>
<?php foreach ($mappings as $code => $m) { ?>
    <tr>
      <td class="text-right">
        <a href="http://swb.bsz-bw.de/DB=2.104/CMD?ACT=SRCHA&IKT=2016&TRM=<?=$code?>"><?=$m['count']?></a>
      </td>
      <td><?=$code?></td>
      <td><?=$m['date']?></td>
    </tr>
<?php } ?>
  </tbody>
</table>

<h3>Wikidata-Mappings</h3>
<p>See <a href="../wikidata">Wikidata-Mappings</a>.</p>

<h3>RVK-Mappings</h3>
<p>See <a href="../">Concordances</a>.</p>

<?php
include "$BASE/footer.php";
