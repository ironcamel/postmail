#!/usr/bin/env perl
use strict;
use warnings;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Sender::Transport::SMTP::TLS;
use Email::Simple;
use JSON qw(from_json);
use FindBin qw($RealBin);
use Net::Stomp;
use Try::Tiny;
use YAML qw(LoadFile);

my %config = %{LoadFile("$RealBin/../config.yml")};
my $transport;
if ($config{postmail}{tls}) {
    $transport = Email::Sender::Transport::SMTP::TLS->new({
        host          => $config{postmail}{email}{host},
        port          => $config{postmail}{email}{port},
        username      => $config{postmail}{email}{username},
        password      => $config{postmail}{email}{password},
    });
} else {
    $transport = Email::Sender::Transport::SMTP->new({
        host          => $config{postmail}{email}{host},
        port          => $config{postmail}{email}{port},
        sasl_username => $config{postmail}{email}{username},
        sasl_password => $config{postmail}{email}{password},
    });
}
my $stomp = Net::Stomp->new({
    hostname => $config{plugins}{Stomp}{postmail}{hostname},
    port     => $config{plugins}{Stomp}{postmail}{port},
});
$stomp->connect();
$stomp->subscribe({
    destination => $config{postmail}{queue},
    ack         => 'client',
});

while (1) {
    my $frame = $stomp->receive_frame;
    my $msg = $frame->body;
    print "sending $msg\n";
    try {
        my $data = from_json($msg);
        send_email($data);
        print "sent email $data->{from} => $data->{to}\n";
    } catch {
        print "failed sending email: $_\n";
    };
    $stomp->ack({ frame => $frame });
}
$stomp->disconnect;

sub send_email {
    my $data = shift;
    my $email = Email::Simple->create(
        header => [
            To      => $data->{to},
            From    => $data->{from},
            Subject => $data->{subject},
        ],
        body => $data->{body},
    );

    sendmail($email, { transport => $transport });
}
