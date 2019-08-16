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

<p id="concordances-stats"></p>

##### ➡  [Browse all concordances and mappings](https://coli-conc.gbv.de/cocoda/app/concordances.html)

🡒  alternatively [open concordances in Cocoda](https://coli-conc.gbv.de/cocoda/app/?concordances)

<script type="text/javascript">
$(document).ready(function(){
  $.getJSON('https://coli-conc.gbv.de/api/concordances', function(list) {
    var total = list.reduce(function (total, cur) {
      return total + (1*cur.extent)
    }, 0)
    var text = "By now we collected " + list.length + " concordances with "
      + total + " mappings."
    $('#concordances-stats').text(text)
  })
})
</script>
