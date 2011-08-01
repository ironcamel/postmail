#!/usr/bin/env perl
use strict;
use warnings;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Net::Stomp;
use JSON qw(from_json);
use Try::Tiny;
use YAML::XS qw(LoadFile);

my %config = %{LoadFile("../config.yml")->{postmail}};
my $transport = Email::Sender::Transport::SMTP->new({
    host          => $config{email}{host},
    port          => $config{email}{port},
    sasl_username => $config{email}{username},
    sasl_password => $config{email}{password},
});
my $stomp = Net::Stomp->new({
    hostname => $config{stomp}{host},
    port     => $config{stomp}{port},
});
$stomp->connect();
$stomp->subscribe({
    destination => $config{stomp}{queue},
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
