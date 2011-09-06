package Postmail;
use Dancer ':syntax';
use Dancer::Plugin::Stomp;

my %config = %{ config->{postmail} };

post '/email' => sub {
    my $body = request->body;
    debug "sending $body";
    stomp->send({
        destination => $config{stomp}{queue},
        body        => $body,
    });
    return "msg queued\n";
};

true;
