#!/usr/bin/perl
package Service;

use strict;
use warnings;

use lib 'server/service/';

use HTMLService;
use CGIService;
# use AirFlightService;
use TicketsService;
use ResourceService;
use LocationService;

sub new {
    my ($class, %args) = @_;

    # Создаем композитный объект с нужными сервисами.
    # Параметры можно передавать через %args, например:
    #   html_base_path => 'server/html',
    #   cgi_base_path  => 'server/cgi',
    #   db_config      => { ... }
    my $self = {
        html_service      => HTMLService->new(
                                base_path => $args{html_base_path}  || 'server/html'
                             ),
        cgi_service       => CGIService->new(
                                base_path => $args{cgi_base_path}   || 'server/cgi'
                             ),
        # airflight_service => AirFlightService->new(
        #                         db_config => $args{db_config}
        #                      ),
        tickets_service   => TicketsService->new(
                                repository => $args{repository}
                             ),
        resource_service => ResourceService->new(base_path => 'server/resource/'),
        location_service => LocationService->new(
                                repository => $args{repository}
                             ),
    };

    bless $self, $class;
    return $self;
}

1;
