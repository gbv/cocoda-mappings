<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>coli-conc<?= $TITLE ? ": $TITLE" : "" ?></title>
    <link rel="stylesheet" href="<?=$BASE?>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<?=$BASE?>/css/font-awesome.min.css">
    <link rel="stylesheet" href="<?=$BASE?>/css/bootstrap-vzg.css">
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>

    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
			<span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="<?=$BASE?>/">coli-conc</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li><a href="<?=$BASE?>/">About</a></li>
            <li><a href="<?=$BASE?>/terminologies/">Terminologies</a></li>
            <li><a href="<?=$BASE?>/concordances/">Concordances</a></li>
            <li><a href="<?=$BASE?>/cocoda/">Cocoda prototype</a></li>
            <li class="active"><a href="../">Publications</a></li>
	    <li><a href="<?=$BASE?>/contact/">Contact</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container">
