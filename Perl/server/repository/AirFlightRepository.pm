#!/usr/bin/perl
package AirFlightRepository;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $self = {
        db => $args{dbh},  # DBI-хендл
    };
    bless $self, $class;
    return $self;
}

# Метод получения всех рейсов
sub get_all_flights {
    my ($self) = @_;

    my $sql = qq{
        SELECT
            f.flight_number,
            (c_dep.name || ', ' || dep_c.name) AS departure_city,
            (c_arr.name || ', ' || arr_c.name) AS arrival_city,
            f.departure_date,
            f.arrival_date,
            f.departure_time,
            f.arrival_time,
            a.name AS airline,
            f.price,
            f.available_tickets,
            f.description,
            f.image
        FROM Flights f
        JOIN Cities c_dep ON f.departure_city_id = c_dep.id
        JOIN Countries dep_c ON c_dep.country_id = dep_c.id
        JOIN Cities c_arr ON f.arrival_city_id = c_arr.id
        JOIN Countries arr_c ON c_arr.country_id = arr_c.id
        JOIN Airlines a ON f.airline_id = a.id
    };

    my $sth = $self->{db}->prepare($sql);
    $sth->execute();

    my @flights;
    while (my $row = $sth->fetchrow_hashref) {
        push @flights, $row;
    }
    return \@flights;
}

# Метод фильтрации рейсов по заданным критериям
sub filter_flights {
    my ($self, $criteria) = @_;

    my @conditions;
    my @params;

    # Добавляем условия в зависимости от переданных критериев
    if ($criteria->{departure_country}) {
        push @conditions, "dep_c.name = ?";
        push @params, $criteria->{departure_country};
    }
    if ($criteria->{departure_city}) {
        push @conditions, "c_dep.name = ?";
        push @params, $criteria->{departure_city};
    }
    if ($criteria->{arrival_country}) {
        push @conditions, "arr_c.name = ?";
        push @params, $criteria->{arrival_country};
    }
    if ($criteria->{arrival_city}) {
        push @conditions, "c_arr.name = ?";
        push @params, $criteria->{arrival_city};
    }
    if ($criteria->{departure_date}) {
        push @conditions, "f.departure_date = ?";
        push @params, $criteria->{departure_date};
    }

    # Формируем SQL-запрос с динамическими условиями
    my $where = @conditions ? "WHERE " . join(" AND ", @conditions) : "";

    my $sql = qq{
        SELECT
            f.flight_number,
            (c_dep.name || ', ' || dep_c.name) AS departure_city,
            (c_arr.name || ', ' || arr_c.name) AS arrival_city,
            f.departure_date,
            f.arrival_date,
            f.departure_time,
            f.arrival_time,
            a.name AS airline,
            f.price,
            f.available_tickets,
            f.description,
            f.image
        FROM Flights f
        JOIN Cities c_dep ON f.departure_city_id = c_dep.id
        JOIN Countries dep_c ON c_dep.country_id = dep_c.id
        JOIN Cities c_arr ON f.arrival_city_id = c_arr.id
        JOIN Countries arr_c ON c_arr.country_id = arr_c.id
        JOIN Airlines a ON f.airline_id = a.id
        $where
    };

    my $sth = $self->{db}->prepare($sql);
    $sth->execute(@params);

    my @flights;
    while (my $row = $sth->fetchrow_hashref) {
        push @flights, $row;
    }
    return \@flights;
}

sub get_flight {
    my ($self, $flight_number) = @_;

    my $sql = qq{
        SELECT
            f.flight_number,
            f.departure_date,
            f.arrival_date,
            c_dep.name AS departure_city,
            dep_c.name AS departure_country,
            c_arr.name AS arrival_city,
            arr_c.name AS arrival_country,
            a.name AS airline,
            f.price,
            f.available_tickets,
            f.description,
            f.image
        FROM Flights f
        JOIN Cities c_dep ON f.departure_city_id = c_dep.id
        JOIN Countries dep_c ON c_dep.country_id = dep_c.id
        JOIN Cities c_arr ON f.arrival_city_id = c_arr.id
        JOIN Countries arr_c ON c_arr.country_id = arr_c.id
        JOIN Airlines a ON f.airline_id = a.id
        WHERE f.flight_number = ?
    };

    my $sth = $self->{db}->prepare($sql);
    $sth->execute($flight_number);
    my $row = $sth->fetchrow_hashref;
    return $row;
}



1;
