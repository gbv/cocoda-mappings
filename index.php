<?php

$BASE = '..';
$SOURCES = 'https://github.com/gbv/cocoda-mappings/';
$TITLE = 'concordances';

include 'header.php';

?>

      <!--p>
        This page provides an early preview of 
        <a href="http://coli-conc.gbv.de/cocoda/api">coli-conc mapping database</a>. 
        <a ng-if="database.version" class="badge" style="background: green" href="{{baseURL}}">
            cocoda-db {{database.version}}
        </a>
      </p-->

      <h3>Mapping Database</h3>
      <div ng-controller="searchMappingsController">
        <div class="row">
        <form class="form-horizontal" ng-submit="requestMappings()">
          <div class="form-group">
            <label class="col-sm-2 control-label">Source</label>
            <div class="col-sm-2">
              <input class="form-control" ng-model="source.scheme" placeholder="scheme"></input>
            </div>
            <div class="col-sm-4">
              <input class="form-control" ng-model="source.notation" placeholder="notation"></input>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Target</label>
            <div class="col-sm-2">
              <input class="form-control" ng-model="target.scheme" placeholder="scheme"></input>
            </div>
            <div class="col-sm-4">
              <input class="form-control" ng-model="target.notation" placeholder="notation"></input>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Creator</label>
            <div class="col-sm-4">
                <input class="form-control" ng-model="creator"></input>
            </div>
            <div class="col-sm-2 text-right">
              <button type="submit" class="btn btn-primary">
                <span class="glyphicon glyphicon-search"></span>
                search
              </button>
            </div>
          </div>
        </form>
        </div>
        <div class="row">
          <div ng-if="retrievedMapping.length"> 
            <div ng-if="mappingCount !== null">
                Found {{mappingCount}} mappings<span 
                  ng-if="retrievedMapping.length < mappingCount">,
                  showing {{retrievedMapping.length}} of them</span>.
            </div>
            <div skos-mapping-table="retrievedMapping" language="language"></div>
          </div>
          <div ng-if="httpError" class="alert alert-danger">
            {{httpError.message}}
          </div>
          <div ng-if="mappingCount === 0" class="alert alert-warning">
            No mappings found for specified query!
          </div>
          <div>
            <ul class="pagin-link-list">
              <li ng-repeat="l in paginationLinks"><a href="" ng-click="requestMappings(l[0])">{{l[1]}} page</a></li>
            </ul>
          </div>
        </div>
        </div>
        
      <h3>List of unified concordances</h3>
<?php      
$kos = [
    'DDC' => [
        'notation' => ['DDC'],
        'uri' => 'http://bartoc.org/en/node/241'
    ],
    'RVK' => [
        'notation' => ['RVK'],
        'uri' => 'http://bartoc.org/en/node/533'
    ],
    'BK' => [
        'notation' => ['BK'],
        'uri' => 'http://bartoc.org/en/node/745'
    ],
    'GND' => [
        'notation' => ['GND'],
        'uri' => 'http://bartoc.org/en/node/430'
    ]
];

foreach (file('csv/concordances.tsv') as $line) {
    list ($from,$to,$about,$count,$creator,$file) = explode("\t",trim($line));
    if (!isset($concordances)) { 
        $concordances = []; continue; 
    } # first line
    if (!file_exists("csv/$file")) {
        continue;
    }
    $concordances[] = [
        'from' => $kos[$from],
        'to' => $kos[$to],
        'about' => $about,
        'creator' => $creator,
        'name' => preg_replace('/\.csv$/','',$file),
        'count' => exec("wc -l csv/$file")-1
    ];    
}

?>
      <p>      
        <table class="table sortable table-hover">
          <thead>
            <th>from</th>
            <th>to</th>
            <th>description</th>
            <th>creator</th>
            <th>download</th>
            <th class="text-right">mappings</th>
          </thead>
          <tbody>
<?php
$total=0;
foreach ($concordances as $con) {
    echo "<tr>";
    echo "<td><a href='{$con['from']['uri']}'>".$con['from']['notation'][0].'</a></td>';
    echo "<td><a href='{$con['to']['uri']}'>".$con['to']['notation'][0].'</a></td>';
    echo "<td>".htmlspecialchars($con['about'])."</td>";
    echo "<td>".htmlspecialchars($con['creator'])."</td>";
    $total += $con['count'];
    echo "<td>";
    foreach (['csv'=>'CSV', 'txt'=>'BEACON', 'ndjson'=>'JSKOS'] as $ext => $name) {
      $file = 'csv/'.$con['name'].".$ext";
      if (file_exists($file)) {
        echo "<a href='$file'>$name</a> ";
      }
    }
    echo "</td>";
    echo "<td class='text-right'>".$con['count'].'</td>';
    echo "</tr>";
}
?>
          </tbody>
          <tfoot>
            <tr>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td class="text-right"><?=$total?></td>
            </tr>
          </tfoot>
        </table>
      </p>

      <h3>Wikidata Mappings</h3>
      <p>
        We daily harvest and convert 
        <a href="wikidata">authority file mappings from Wikidata</a>.
      </p>
      
     <h3>Your suggestions</h3>
      <p> For suggestions, improvements or corrections, please use the form below.</p>
      <p>  We are looking forward to your contributions.</p>
          <p>
    <div id="modal_wrapper">
    <div id="modal_window">

    <form action="mailto:coli-conc@gbv.de"id="modal_feedback" method="POST" enctype="text/plain">
        <p><label>Your Name<strong>*</strong><br>
        <input type="text" autofocus required size="48" name="Name: " value=""></label></p>
        
        <p><label>Email Address<strong>*</strong><br>
        <input type="email" required title="Please enter a valid email address" size="48" name="Email: " value=""></label></p>
        
        <p><label>Source notation<br>
        <input type="text" size="48" name="Source notation: " value=""></label></p>
        
        <p><label>Target notation<br>
        <input type="text" size="48" name="Target notation: " value=""></label></p>
        
        <p><label>Comments<strong>*</strong><br>
        <textarea required name="Comment: " cols="48" rows="8"></textarea></label></p>
        
        <p><input type="submit" value="Send Message" ></p>
    </form>

    </div> <!-- #modal_window -->
    </div> <!-- #modal_wrapper -->
      </p>
      
      
      <h3>Documentation</h3>
      <p>
        Coli-conc mapping database is accessible 
        <a href="https://gbv.github.io/jskos-api">JSKOS-API</a>
        at <a href="{{baseURL}}">{{baseURL}}</a>.
        See 
        <i class="fa fa-github"></i>
        <a href="https://github.com/gbv/cocoda-db">GitHub repository</a>
        for source code and technical documentation.
      </p>
    </div>
<?php

include 'footer.php';
