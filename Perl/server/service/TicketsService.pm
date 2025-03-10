#!/usr/bin/perl
package TicketsService;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    die "Не передан объект repository" unless $args{repository};
    
    my $self = {
        repository => $args{repository},
    };
    bless $self, $class;
    return $self;
}

sub register_ticket {
    my ($sefl, $request) = @_;
      # Извлекаем тело запроса, в котором параметры объединены символом &
    my $body = $request->{body} // '';

    print "ТЕЛО: $body\n";
    
    # Парсим строку в хэш параметров
    my %params;
    for my $pair (split /&/, $body) {
        my ($key, $value) = split /=/, $pair, 2;
        # Декодируем URL-encoded значения
        # $key   = uri_unescape($key   // '');
        # $value = uri_unescape($value // '');
        # Декодируем в UTF-8, если необходимо
        $params{$key} = $value;
    }

     print "ВЫВОД МАССИВА\n";
     foreach my $key (keys %params) {
        print STDERR "$key = $params{$key}\n";
    }
}

1;