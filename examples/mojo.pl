#!/usr/bin/env perl
use strict;
use warnings;

use Mojolicious::Lite;
use lib::abs('../lib');
use JS::HighCharts;


get '/' => sub {
    my $self = shift;

    my $hc =  JS::HighCharts->new();
    $hc->set_chart_type('line');
    $hc->add_series({
            name => 'Jane',
            data => [1, 0, 4],
    });
     $hc->add_series({
            name => 'Petya',
            data => [1, 6, 8],
    });

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
