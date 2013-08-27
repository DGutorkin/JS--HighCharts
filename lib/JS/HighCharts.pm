package JS::HighCharts;

use Modern::Perl;
use warnings FATAL => 'all';

=head1 NAME

JS::HighCharts - Perl wrapper for fun usage of HighCharts JS library

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This is just a wrapper for JavaScript library - HighCharts. 
This module simplify getting cool charts by creating typical perl objects and setting appropriate attributes.

    use JS::HighCharts;

    my $hc = JS::HighCharts->new(
        lib_src => [ ],
        ...
    );

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


sub new {
    my $class = shift;

    my %self = ();
    %self = %$class if ref $class;

    $class = ref $class || $class;
    %self = (%self, @_);

    my $self = \%self;

    $self->{lib_src} //= [ 'http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js', 'http://code.highcharts.com/highcharts.js' ];
    $self->{lib_src} = join "\n", map { "<script src='$_'></script>" } @{ $self->{lib_src} };

    $self->{js} //= "
    <script>
    \$(function () { 
    \$('#container').highcharts({
        chart: {
            type: 'bar'
        },
        title: {
            text: 'Fruit Consumption'
        },
        xAxis: {
            categories: ['Apples', 'Bananas', 'Oranges']
        },
        yAxis: {
            title: {
                text: 'Fruit eaten'
            }
        },
        series: [{
            name: 'Jane',
            data: [1, 0, 4]
        }, {
            name: 'John',
            data: [5, 7, 3]
        }]
    });
});
//
</script>
    ";
     $self->{container} //= '
     <div id="container" style="width:100%; height:400px;"></div>
     ';

    bless $self, $class;
    return $self;
}


sub get_chart {
    my $self = shift;

    return {
        lib_src => $self->{lib_src},
        js => $self->{js},
        container => $self->{container},
    };
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
