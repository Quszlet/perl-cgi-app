#!/usr/bin/perl
package LocationRepository;

use strict;
use warnings;
use Data::Dumper;

sub new {
    my ($class, %args) = @_;
    
    # Проверяем, что dbh передан и не является undefined
    die "Не передан объект dbh для базы данных" unless $args{dbh};
    
    my $self = {
        dbh => $args{dbh},  # DBI-хендл
    };
    
    bless $self, $class;
    return $self;
}

# Метод для получения всех стран
sub get_all_countries {
    my ($self) = @_;
    
    # Проверяем, что db существует
    die "Объект базы данных не инициализирован" unless $self->{dbh};

    my $sql = "SELECT name FROM Countries ORDER BY name";
    my $sth = $self->{dbh}->prepare($sql);
    $sth->execute();

    my @countries;
    while (my ($country_name) = $sth->fetchrow_array) {
        # Отладочная информация
        print STDERR "Country from DB: $country_name\n";
        push @countries, $country_name;
    }
    
    # Отладочная информация
    print STDERR "All countries: " . Dumper(\@countries) . "\n";
    
    return \@countries;
}

# Метод для получения городов по стране
sub get_cities_by_country {
    my ($self, $country_name) = @_;

    my $sql = qq{
        SELECT c.name
        FROM Cities c
        JOIN Countries co ON c.country_id = co.id
        WHERE co.name = ?
        ORDER BY c.name
    };

    my $sth = $self->{dbh}->prepare($sql);
    $sth->execute($country_name);

    my @cities;
    while (my ($city_name) = $sth->fetchrow_array) {
        push @cities, $city_name;
    }
    return \@cities;
}

# Метод для получения города по ID
sub get_city_by_id {
    my ($self, $city_id) = @_;

    my $sql = qq{
        SELECT c.name, co.name
        FROM Cities c
        JOIN Countries co ON c.country_id = co.id
        WHERE c.id = ?
    };

    my $sth = $self->{dbh}->prepare($sql);
    $sth->execute($city_id);

    my ($city_name, $country_name) = $sth->fetchrow_array;
    return {
        city => $city_name,
        country => $country_name
    };
}

# Метод для получения ID города по названию и стране
sub get_city_id {
    my ($self, $city_name, $country_name) = @_;

    my $sql = qq{
        SELECT c.id
        FROM Cities c
        JOIN Countries co ON c.country_id = co.id
        WHERE c.name = ? AND co.name = ?
    };

    my $sth = $self->{dbh}->prepare($sql);
    $sth->execute($city_name, $country_name);

    my ($city_id) = $sth->fetchrow_array;
    return $city_id;
}

1; 