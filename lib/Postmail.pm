package Postmail;
use Dancer ':syntax';
use Net::Stomp;

my %config = %{ config->{postmail} };

post '/email' => sub {
    my $body = request->body;
    my $stomp = Net::Stomp->new({
        hostname => $config{stomp}{host},
        port     => $config{stomp}{port},
    });
    $stomp->connect();
    debug "sending $body";
    $stomp->send({
        destination => $config{stomp}{queue},
        body        => $body,
    });
    $stomp->disconnect;
    return "msg queued\n";
};

true;
