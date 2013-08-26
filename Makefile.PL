use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'JS::HighCharts',
    AUTHOR           => q{MDn <maddemon@gmail.com>},
    VERSION_FROM     => 'lib/JS/HighCharts.pm',
    ABSTRACT_FROM    => 'lib/JS/HighCharts.pm',
    LICENSE          => 'perl',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    TEST_REQUIRES => {
        'Mojolicious::Lite' => 0,
    },
    PREREQ_PM => {
        'Template' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'JS-HighCharts-*' },
);
