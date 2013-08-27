#  JS::HighCharts

This is just a wrapper for JavaScript library - HighCharts. 
This module simplify getting cool charts by creating typical perl objects and setting appropriate attributes.

# Usage
```Perl
    use JS::HighCharts
    my $hc = JS::HighCharts->new(
        lib_src => [ ],
        #parameters
    );
```
After setting an object, you'll get all JavaScript/HTML code back by calling method:
```Perl
    my $chart = $hc->get_chart;
```

For Mojolicious put this on your stash:
```Perl
  	$self->stash->{chart} = $chart;
```
You can use this in your templates (ex. Template::Toolkit) or even plain CGI by setting 3 variables:
```HTML
    <head>
        [% chart.lib_src %]
        [% chart.js %]
    </head>
    <body>
        [% chart.container %]
    </body>
```
And this is all you need to get the cool chart, provided by HighCharts library ;)
