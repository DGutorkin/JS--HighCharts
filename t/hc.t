#!/usr/bin/env perl

use Test::More 'no_plan';
use lib::abs ('../lib');
use warnings FATAL => 'all';


BEGIN {
    use_ok( ' JS::HighCharts' ) || print "Cannot load  JS::HighCharts\n";
}

my $hc =  JS::HighCharts->new();

ok(defined $hc->{'lib_src'}, "Default lib source path exists");
ok(defined $hc->{'js'}, "Default JS-code exists");
ok(defined $hc->{'container'}, "Default container exists");
