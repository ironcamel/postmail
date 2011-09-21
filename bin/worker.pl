#!/usr/bin/env perl
use strict;
use warnings;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Net::Stomp;
use JSON qw(from_json);
use FindBin qw($RealBin);
use Try::Tiny;
use YAML::XS qw(LoadFile);

my %config = %{LoadFile("$RealBin/../config.yml")};
my $transport = Email::Sender::Transport::SMTP->new({
    host          => $config{postmail}{email}{host},
    port          => $config{postmail}{email}{port},
    sasl_username => $config{postmail}{email}{username},
    sasl_password => $config{postmail}{email}{password},
});
my $stomp = Net::Stomp->new({
    hostname => $config{plugins}{Stomp}{postmail}{host},
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
