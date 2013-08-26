#  JS::HighCharts

Perl wrapper for fun usage of HighCharts JS library


# Usage

    use JS::HighCharts
    my $hc = JS::HighCharts->new(
        #parameters
    );

For Mojolicious put this on your stash:

  $self->stash->{hc} =  $hc;

And don't forget to include three parts in your template:

    $hc->{src_lib}; # contains lib to your HighCharts distribution
    $hc->{js}; # general JavaScript code (this module simplify exactly this part)
    $hc->{container}; # put it where you are planning to see graph