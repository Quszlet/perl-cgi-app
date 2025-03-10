#!/usr/bin/perl
package Repository;

use strict;
use warnings;
use DBI;

use lib 'server/repository';

use TicketsRepository;
use AirFlightRepository;
use LocationRepository;

sub new {
    my ($class, %args) = @_;
    my $self = {
        air_flight_repo => AirFlightRepository->new(dbh => $args{dbh}),
        location_repo   => LocationRepository->new(dbh => $args{dbh}),
        tickets_repo   => TicketsRepository->new(dbh => $args{dbh}),
    };

    
    bless $self, $class;
    return $self;
}

1;
