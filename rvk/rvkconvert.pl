#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;
use JSON;
use Data::Dumper;
use Path::Class;

my $filename = 'rvko_2015_4.xml';
my $json = 'rvk_2015_4.json';
my $conv = JSON->new->utf8;
my $dump = file('dump.json');
my $dout = $dump->openw();

if (-e $json) {
  unlink $json;
} 

my $parser = XML::LibXML->new();
my $doc    = $parser->parse_file($filename);
my $c = 0;

foreach my $node ($doc->findnodes('//node')) {
  my %new;
  $new{'prefLabel'}{'de'} = $node->getAttribute('benennung');
  $new{'notation'}[0] = $node->getAttribute('notation');
  $new{'inScheme'}[0]{'notation'}[0] = 'RVK';
  $new{'inScheme'}[0]{'uri'} = "http://d-nb.info/gnd/4449787-8";
  my($children) = $node->findnodes('./children');
  if($children){
    $new{'narrower'} = [];
    foreach my $child ($children->findnodes('./node')){
      my($childNotation) = $child->getAttribute('notation');
      my($childLabel) = $child->getAttribute('benennung');
      push $new{'narrower'}, { notation => $childNotation, prefLabel => { de => $childLabel } };
    }
  }
  
  my($notes) = $node->findnodes('./content');
  my $bemerkung;
  if($notes){
    $bemerkung = $notes->getAttribute('bemerkung');
  }
  my $reg;
  my($register) = $node->findnodes('./register');
  if($register){
    $reg = "Register:";
    foreach my $entry ($node->findnodes('./register')){
      my $add = $entry->textContent;
      $add =~ s/\s+$//;
#       print Dumper($add);
      $reg .= " $add.";
      
    }
  }
  if($notes || $register){
    $new{'scopeNote'}{'de'} = [];
    if($notes){
      push $new{'scopeNote'}{'de'}, $bemerkung;
    }
    if($register){
      push $new{'scopeNote'}{'de'}, $reg;
    }
  }
  
  my $not = $new{'notation'}[0];
  my $parentC = $node->parentNode;
  if($parentC->nodeName eq 'children'){
    my $parent = $parentC->parentNode;
    $new{'broader'} = [];
    my $broaderNot = $parent->getAttribute('notation');
    my $broaderLabel = $parent->getAttribute('benennung');
    push $new{'broader'}, { notation => $broaderNot, prefLabel => { de => $broaderLabel } };
  }
  my $enc_json = $conv->pretty->encode(\%new);
  open(my $js, '>>', $json) or die "No output file!";
  print $js $enc_json;
  close $js;
  $c++;
  if($c % 1000 == 0){
    print "$c nodes processed!\n";
  }
}

