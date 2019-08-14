<?php
$BASE = '..';
$TITLE = 'Concordance Registry';
$FORMAT = 'markdown';
require_once "$BASE/vendor/autoload.php";
include "$BASE/header.php";
?>

We collect concordances and mappings in a public database run with
[jskos-server](https://github.com/gbv/jskos-server). The database can be
queried via this web interface and via an API at
<https://coli-conc.gbv.de/api/>.


<table class="table table-sm" id="release-table">
 <tr>
   <th>from</th>
   <th>to</th>
   <th>description</th>
   <th>creator</th>
   <th>date</th>
   <th style="text-align: right">mappings</th>
   <!--th>download</th-->
   <th></th>
 </tr>
</table>

→ [See all concordances in Cocoda](https://coli-conc.gbv.de/cocoda/app/?concordances).

<script type="text/javascript">
$(document).ready(function(){
  $.getJSON('https://coli-conc.gbv.de/api/concordances', function(list) {
    list.forEach( function(conc) {
      var row = $('<tr>')
      // TODO: use utility method to safe deep object access
      row.append('<td>'+conc.fromScheme.notation[0]+'</td>')
      row.append('<td>'+conc.toScheme.notation[0]+'</td>')
      row.append('<td>'+conc.scopeNote.de[0]+'</td>')
      row.append('<td>'+conc.creator[0].prefLabel.de+'</td>')
      row.append('<td>'+(conc.created || '')+'</td>')
      row.append('<td align="right">'+(conc.extent || '')+'</td>')
      // TODO: get downloads from conc.distributions
      var url = "https://coli-conc.gbv.de/cocoda/app/concordances.html?search="
      + encodeURI(JSON.stringify({partOf: conc.uri}))
      row.append('<td>→ <a href="'+url+'">Mappings</a></td>')
      $('#release-table').append(row)
    })
  })
})
</script>
