use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Postmail',
    VERSION             => 1.0,
    PL_FILES            => {},
    PREREQ_PM => {
        'Authen::SASL'                        => 0,
        'Email::Sender'                       => 0, 
        'Email::Sender::Transport::SMTP::TLS' => 0, 
        'Email::Simple'                       => 0,
        'Dancer::Plugin::Stomp'               => 0,
        'JSON Starman'                        => 0, 
        'MIME::Base64'                        => 0,
        'Try::Tiny'                           => 0, 
        'YAML'                                => 0,
    },
    dist      => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean     => { FILES => 'Postmail-*' },
    test      => { TESTS => join( ' ', (glob( 't/*.t'), glob('t/*/*.t')))},
);
