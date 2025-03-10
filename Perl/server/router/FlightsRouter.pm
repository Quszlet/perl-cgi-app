#!/usr/bin/perl
package FlightsRouter;

use strict;
use warnings;
use lib 'server/parse/';
use HttpResponse;
use URI::Escape qw(uri_unescape);
use Encode qw(decode_utf8);

sub new {
    my ($class, %args) = @_;
    my $self = { service => $args{service} };
    bless $self, $class;
    return $self;
}

sub route {
    my ($self, $request) = @_;
    my $path = $request->{path} || '/flights';
    my $content = '';

    print "ПУТЬ В РЕЙСАХ: $path";
    
    if ($path eq '/flights') {
        $content = $self->{service}->{cgi_service}->serve_flights();
    }
    elsif ($path =~ m{/flights/flights\.cgi}) {
        my ($script, $query_string) = split /\?/, $path, 2;
        my %params;
        
        # Разбираем параметры запроса, если строка не пустая
        if ($query_string) {
            foreach my $pair (split /&/, $query_string) {
                my ($key, $value) = split /=/, $pair, 2;
                $value = uri_unescape($value // '');
                $value = decode_utf8($value);
                $params{$key} = $value if defined $value && $value ne '';
            }
        }
        
        # Получаем отфильтрованные рейсы, если параметры заданы
        $content = $self->{service}->{cgi_service}->serve_flights(\%params);
    }
    else {
        $content = "HTTP/1.1 404 Not Found\r\n\r\nFlightsRouter: Страница не найдена";
    }
    
    return $content;
}

1;
