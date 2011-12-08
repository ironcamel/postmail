use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Postmail',
    AUTHOR        => 'Naveed Massjouni <naveedm9@gmail.com>',
    VERSION_FROM  => 'lib/Postmail.pm',
    ABSTRACT_FROM => 'lib/Postmail.pm',
    PREREQ_PM => {
        'Authen::SASL'                        => 0,
        'Email::Sender'                       => 0, 
        'Email::Sender::Transport::SMTP::TLS' => 0, 
        'Email::Simple'                       => 0,
        'Dancer::Plugin::Stomp'               => 0,
        'JSON'                                => 0, 
        'MIME::Base64'                        => 0,
        'Starman'                             => 0, 
        'Try::Tiny'                           => 0, 
        'YAML'                                => 0,
    },
);
