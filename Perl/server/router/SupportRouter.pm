#!/usr/bin/perl
package SupportRouter;

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
     print "Зашли в маршрутизаторе в support\n";
    if ($request->{path} eq '/support') {
        $content = $self->{service}->{html_service}->serve_support();
    }
    elsif ($request->{path} =~ m{/support/support_submit\.cgi}) {
        print "Зашли в маршрутизаторе в support_submit\n";
        $content = $self->{service}->{cgi_service}->serve_support_submit($request);
    }
    return $content;
}

1;
