#!/usr/bin/perl
package AirFlightsService;

use strict;
use warnings;

# Конструктор принимает параметр repository
sub new {
    my ($class, %args) = @_;
    # Обязательно передаем объект репозитория
    die "Не передан объект repository" unless $args{repository};
    
    my $self = {
        repository => $args{repository},
    };
    bless $self, $class;
    return $self;
}

# Метод get_all_flights обращается к Repository и достает все записи из таблицы Flights
sub get_all_flights {
    my ($self) = @_;
    return $self->{repository}->{air_flight_repo}->get_all_flights();
}

# Метод filter_flights получает критерии фильтрации и передает их в репозиторий
sub filter_flights {
    my ($self, $criteria) = @_;
    return $self->{repository}->{air_flight_repo}->filter_flights($criteria);
}

sub get_flight {
    my ($self, $flight_number) = @_;
    return $self->{repository}->{air_flight_repo}->get_flight($flight_number);
}

1;
