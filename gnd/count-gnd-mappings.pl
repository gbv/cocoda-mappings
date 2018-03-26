#!/usr/bin/env perl
use v5.14;
use Catmandu -all;
use POSIX;

my $date = POSIX::strftime '%Y%m%d', localtime;

foreach my $code (<>) {
    chomp $code;
    my $count = importer('SRU', 
        base => 'http://sru.gbv.de/ognd',
        query => "pica.stn=$code",
        limit => 0,
        parser => 'meta'
    )->first->{numberOfRecords};
    say join ',', $date, $code, $count;
    sleep 1;
}
