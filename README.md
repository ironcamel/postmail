# About

Postmail is a simple REST based service for sending email. Similar to Amazon's
Simple Email Service.

# Installation

First install dependencies:

    sudo cpanm Dancer Email::Sender Email::Simple Net::Stomp Plack JSON Try::Tiny YAML::XS

# Usage

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
