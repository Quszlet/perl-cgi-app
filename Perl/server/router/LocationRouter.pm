#!/usr/bin/perl
package LocationRouter;

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

    my $path = $request->{path} || '';

    my $content = '';
    
    if ($path eq '/location/country') {
        # Получение списка всех стран
        my $content = $self->{service}->{location_service}->get_countries();
        return HttpResponse->new(
            status => 200,
            headers => {
                'Content-Type' => 'application/json; charset=utf-8'
            },
            content => $content
        );
    }
    elsif ($path =~ m{^/location/cities/(.+)$}) {
        # Получение городов для конкретной страны
        my $encoded_country = $1;
        my $country = decode_utf8(uri_unescape($encoded_country));
        
        my $content = $self->{service}->{location_service}->get_cities_by_country($country);
        return HttpResponse->new(
            status => 200,
            headers => {
                'Content-Type' => 'application/json; charset=utf-8'
            },
            content => $content
        );
    }
    else {
        $content = "HTTP/1.1 404 Not Found\r\n\r\nLocationRouter: Страница не найдена";
    }
    
    return $content;
}

1; 