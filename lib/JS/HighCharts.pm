package JS::HighCharts;

use Modern::Perl;
use warnings FATAL => 'all';
use JSON;
use Data::Dumper;

=head1 NAME

JS::HighCharts - Perl wrapper for fun usage of HighCharts JS library

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

This is just a wrapper for JavaScript library - HighCharts. 
This module simplify getting cool charts by creating typical perl objects and setting appropriate attributes.

    use JS::HighCharts;

    my $hc = JS::HighCharts->new(
        lib_src => [ ],
        ...
    );

Now you have to draw something on your chart. You need at least one data collection:

    $hc->add_series({
        name => 'Vovka',
        data => [1, 2, 3, 4, 5],
    });

You can also set all titles and types in one expression:
    $hc->set_chart_type('line')->set_title('New chart')->set_y_title('This is subtitile');

After setting an object, you'll get all the code you need back by calling method:

    my $chart = $hc->get_chart;

You can use this in your templates (ex. Template::Toolkit) by setting 3 variables:

    <head>
        [% chart.lib_src %]
        [% chart.js %]
    </head>
    <body>
        [% chart.container %]
    </body>

And this is all you need to get the cool chart, provided by HighCharts library ;)

=cut

my $json  = JSON->new->allow_nonref;;

=head2 set_chart_type

Set chart type. 'bar' and 'line' types tested successfully.
    $hc->set_chart_type('bar');
Default value is 'bar'.

=cut

sub set_chart_type {
    my ($self, $type) = @_;

    $self->{required_data}->{chart}->{type} = "$type";
    return $self;
}

=head2 set_title

Set chart title.
    $hc->set_title('New great chart!');
Default value for development time is: Fruit Consumption ;)

=cut

sub set_title {
    my ($self, $title) = @_;

    $self->{required_data}->{title}->{text} = "$title";
    return $self;
}

=head2 set_subtitle

Set chart subtitle.
    $hc->set_subtitle('Source: ');

=cut

sub set_subtitle {
    my ($self, $subtitle) = @_;

    $self->{required_data}->{subtitle}->{text} = "$subtitle";
    return $self;
}

=head2 use_hash

Easiest way to get chart from single hash.

    $hc->use_hash(%data);

=cut

sub use_hash {
    my ($self, %hash) = @_;

    my @categories = keys %hash;
    my @series = values %hash;
    $self->set_x_axis([@categories]);
    $self->add_series({
        name => 'Chart data',
        data => [@series],
        });

    return $self;
}

=head2 set_x_axis

Set collection on values for X axis. Use anonymous array as parameter.

    $hc->set_x_axis(['a', 'b', 'c']);
Default value for development time is: ['Apples', 'Bananas', 'Oranges']

=cut

sub set_x_axis {
    my $self = shift;

    my $params = shift;
    my @categories = ();

    @categories= @$params if ref $params;
    @categories = (@categories, @_);

    $self->{required_data}->{xAxis}->{categories} = [ @categories ];

    return $self;
}

=head2 set_y_title

Set Y axis title.
    $hc->set_y_title('New subtitle');
Default value for development time is: Fruit eaten

=cut

sub set_y_title {
    my ($self, $title) = @_;

    $self->{required_data}->{yAxis}->{title}->{text} = "$title";
    return $self;
}

=head2 add_series

This method define chart data: name and yAxis values.
    $hc->add_series({
        name => 'New line',
        data => [1, 2, 3, 4],
    });

=cut

sub add_series {
    my $self = shift;
    my $params = shift;
    my @data;
    foreach my $elem (@{$params->{data}}) {
        push @data, $elem +0; # converting to numeric values
    }
    push @{ $self->{required_data}->{series} }, { name => $params->{name}, data => \@data };

    return $self;
}

=head2 extend

This method allows you to extend this module functionality by using native HichCharts API, through serializiation Perl structures into JSON.
    $hc->extend({
        plotOptions => 
        {
            series => {
                marker => {
                    enabled => 'false',
                    symbol => 'circle',
                    radius => 2,
                }
            }
        }
    });

=cut

sub extend {
    my $self = shift;
    my $params = shift;

    foreach my $key (keys %{$params}) {
        if (exists $self->{required_data}{$key}) {
            # this part is iterating over nesting hash, should take it into the separate method
            if ( ref($params->{$key}) eq 'HASH' ) {
                foreach my $inner_key (keys%{$params->{$key}}) { 
                    $self->{required_data}{$key}{$inner_key} =  $params->{$key}->{$inner_key};
                }
            }
            # end of iterating part
        } 
        else {
            $self->{required_data}{$key} =  $params->{$key}
        }
    }

    return $self;
}


=head2 get_chart

Call this method after setting chart data. 
You'll get back hashref, which contains all you need to put chart in your template (or anything else). (see also SYNOPSIS)
    my $graph = $hc->get_chart;

=cut


sub get_chart {
    my $self = shift;

    #$self->{required_data}->{chart}->{type} //= 'bar';
    $self->{required_data}->{title}->{text} //= 'Chart data';
    $self->{required_data}->{xAxis}->{categories} //= ['Apples', 'Bananas', 'Oranges'];
    $self->{required_data}->{yAxis}->{title}->{text} //= 'y axis';

    my $bytes = $json->encode($self->{required_data});
    my $lib_src = $self->{lib_src};

    return {
        lib_src => $self->{lib_src},
        js => $self->_make_js_wrap($bytes),
        container => $self->{container},
    };
}

sub _make_js_wrap {
    my ($self, $json) = @_;

    return "<script>
    \$(function () { 
    \$('#container').highcharts($json);
    });
//
</script>";
}


sub new {
    my $class = shift;

    my %self = ();
    %self = %$class if ref $class;

    $class = ref $class || $class;
    %self = (%self, @_);

    my $self = \%self;

    $self->{lib_src} //= [ 'https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js', 'https://code.highcharts.com/highcharts.js' ];
    $self->{lib_src} = join "\n", map { "<script type='text/javascript' src='$_'></script>" } @{ $self->{lib_src} };

     $self->{container} //= '
     <div id="container" style="width:100%; height:400px;"></div>
     ';

     $self->{required_data} = {}; # this is general hash for serialization to JSON.

    bless $self, $class;
    return $self;
}

=head1 AUTHOR

MDn, C<< <maddemon at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-js-highcharts at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=JS-HighCharts>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc JS::HighCharts


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=JS-HighCharts>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/JS-HighCharts>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/JS-HighCharts>

=item * Search CPAN

L<http://search.cpan.org/dist/JS-HighCharts/>

=back

=head1 SEE ALSO

L<http://www.highcharts.com>, L<Template>, L<Mojolicious::Plugin::TtRenderer>.


=head1 LICENSE AND COPYRIGHT

Copyright 2013 MDn.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of JS::HighCharts
