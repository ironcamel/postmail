package Postmail;
use Dancer ':syntax';
use Dancer::Plugin::Stomp;

our $VERSION = '0.0001';

post '/email' => sub {
    my $body = request->body;
    debug "sending $body";
    stomp->send({
        destination => config->{postmail}{queue},
        body        => $body,
    });
    return "msg queued\n";
};

true;

=head1 NAME

Postmail - Scalable, REST based service for sending email. 

=cut
