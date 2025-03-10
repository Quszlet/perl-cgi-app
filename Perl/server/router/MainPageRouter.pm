#!/usr/bin/perl
package MainPageRouter;

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
    my $path = $request->{path} || '/';
    my $content = '';
    
    if ($path eq '/' or $path eq '/main') {
        $content = $self->{service}->{html_service}->serve_main();
    }
    elsif ($path eq '/header') {
        $content = $self->{service}->{html_service}->serve_header();
    }
    elsif ($path eq '/menu') {
        $content = $self->{service}->{html_service}->serve_menu();
    }
    elsif ($path eq '/content') {
        $content = $self->{service}->{html_service}->serve_content();
    }
    else {
        $content = "HTTP/1.1 404 Not Found\r\n\r\nСтраница не найдена";
    }
    
    return $content;
}

1;
