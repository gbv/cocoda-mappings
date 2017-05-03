<?php

$BASE = '..';
$SOURCES = 'https://github.com/gbv/cocoda-mappings/';
$TITLE = 'concordances';

include 'header.php';

?>
      <p>
        <ul>
          <li>Mapping Database</li>
          <li><a href="wikidata">Wikidata Mappings</a></li>
        </ul>
      </p>

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
