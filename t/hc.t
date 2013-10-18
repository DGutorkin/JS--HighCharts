#!/usr/bin/env perl

use Test::More 'no_plan';
use lib::abs ('../lib');
use Data::Dumper;
use warnings FATAL => 'all';


BEGIN {
    use_ok( ' JS::HighCharts' ) || print "Cannot load  JS::HighCharts\n";
}

my $hc =  JS::HighCharts->new();

ok(defined $hc->{'lib_src'}, "Default lib source path exists");
ok(defined $hc->{'container'}, "Default container exists");


my $z = $hc->get_chart;

my @required_keys = grep /lib_src|js|container/, keys $z;
ok (scalar @required_keys eq '3', "Required keys returned in chart hashref");