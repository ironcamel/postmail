# About

Postmail is a simple REST based service for sending email. Similar to Amazon's
Simple Email Service.

# Installation

First install dependencies:

    sudo cpanm Dancer Email::Sender Email::Sender::Transport::SMTP::TLS Email::Simple Dancer::Plugin::Stomp Plack JSON Try::Tiny YAML YAML::XS

# Usage

Edit the config.yml file to configure your Stomp message broker and SMTP server settings.

Start the server:

    ./bin/app.pl

Start the worker:

    ./bin/worker.pl

Send an email:

    lwp-request -m POST http://localhost:3000/email <<EOD
    {
        "from":    "bob@foo.com",
        "to":      "joe@foo.com",
        "subject": "hi from postmail",
        "body":    "bye"
    }
    EOD

# Stomp Message Broker

It is very easy to get a Stomp message broker up and running:

    sudo cpanm POE::Component::MessageQueue
    mq.pl

Running `mq.pl` will start a broker on localhost listening on port 61613.
The default stomp settings in config.yml will then just work.
