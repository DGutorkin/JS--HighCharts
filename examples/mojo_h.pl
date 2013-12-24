#!/usr/bin/env perl
use strict;
use warnings;

use Mojolicious::Lite;
use lib::abs('../lib');
use JS::HighCharts;

my %hash2;
foreach my $file ( glob("../*.*") ) {
    $hash2{$file} = -s $file;
}

get '/' => sub {
    my $self = shift;

    my $hc =  JS::HighCharts->new();    # or you can use it locally: lib_src => ['js/jquery-1.8.3.js','js/highcharts.js'];
    $hc->set_chart_type('column')->set_title('Direcroty size');
    $hc->use_hash(%hash2);

    $self->stash->{chart} =  $hc->get_chart;
} => 'index';

app->start;

__DATA__
@@ index.html.ep

 <html>
    <head>
        <%== $chart->{lib_src} %>
        <%== $chart->{js} %>
    </head>

    <body><%== $chart->{container} %></body>
</html>
