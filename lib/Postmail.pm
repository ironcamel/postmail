package Postmail;
use Dancer ':syntax';
use Dancer::Plugin::Stomp;

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
