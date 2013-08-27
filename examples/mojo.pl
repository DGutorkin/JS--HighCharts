#!/usr/bin/env perl
use strict;
use warnings;

use Mojolicious::Lite;
use lib::abs('../lib');
use JS::HighCharts;


get '/' => sub {
    my $self = shift;

    my $hc =  JS::HighCharts->new();
    my $chart = $hc->get_chart;
    $self->stash->{chart} =  $chart;  
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