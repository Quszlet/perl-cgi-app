#!/usr/bin/perl
package LocationService;

use strict;
use warnings;
use JSON;
use Encode qw(encode_utf8 decode_utf8);
use Data::Dumper;

sub new {
    my ($class, %args) = @_;

    die "Не передан объект repository" unless $args{repository};
    
    my $self = {
        repository => $args{repository},
    };
    bless $self, $class;
    return $self;
}

# Метод get_countries возвращает список всех стран в формате JSON
sub get_countries {
    my ($self) = @_;
    my $countries = $self->{repository}->{location_repo}->get_all_countries();
    
    # Преобразуем каждую строку в UTF-8 перед JSON-кодированием
    my @utf8_countries = map { decode_utf8($_) } @$countries;
    
    # print STDERR "Countries after UTF-8 decode: " . Dumper(\@utf8_countries) . "\n";
    
    my $json = JSON->new->utf8->encode(\@utf8_countries);
    
    # print STDERR "JSON after encoding with UTF-8: $json\n";
    
    return $json;
}

# Метод get_cities_by_country возвращает список городов для указанной страны в формате JSON
sub get_cities_by_country {
    my ($self, $country) = @_;
    my $cities = $self->{repository}->{location_repo}->get_cities_by_country($country);
    
    # Аналогично для городов
    my @utf8_cities = map { decode_utf8($_) } @$cities;
    return JSON->new->utf8->encode(\@utf8_cities);
}

1; 