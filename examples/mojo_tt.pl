#!/usr/bin/env perl
use strict;
use warnings;

use Mojolicious::Lite;
use Mojolicious::Plugin::TtRenderer;

use lib::abs('../lib');
use JS::HighCharts;



plugin tt_renderer => { template_options => { DEBUG => 1 } };

get '/' => sub {
    my $self = shift;

    # hashref $hc should be taken from JS::HighCharts
    my $hc =  JS::HighCharts->new();

  $self->stash->{hc} =  $hc;
  $self->render('test');
};

app->renderer->default_handler( 'tt' );

app->start;