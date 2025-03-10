#!/usr/bin/perl
package TicketRouter;

use strict;
use warnings;

use lib 'server/parse/';

use HttpResponse;

sub new {
    my ($class, %args) = @_;
    my $self = { service => $args{service} };
    bless $self, $class;
    return $self;
}

sub route {
    my ($self, $request) = @_;
    my $content;
    
    if ($request->{path}  =~ m{/tickets/tickets\.cgi}) {
        $content = $self->{service}->{cgi_service}->serve_ticket($request);
    } 
    elsif ($request->{path} eq '/tickets/submit') {
        $content = $self->{service}->{tickets_service}->register_ticket($request);
    }
    else {
        $content = "HTTP/1.1 404 Not Found\r\n\r\nСтраница не найдена";
    }

    return $content;
}

1;
