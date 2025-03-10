#!/usr/bin/perl
package Router;

use strict;
use warnings;

use lib 'server/parse/';
use lib 'server/service/';
use lib 'server/router/';
use HttpResponse;

# Подключаем суб-модули маршрутизации
use MainPageRouter;
use FlightsRouter;
use TicketRouter;
use SupportRouter;
use ResourceRouter;
use LocationRouter;

# Конструктор принимает параметр 'service' – композитный объект, содержащий все необходимые сервисы
sub new {
    my ($class, %args) = @_;
    
    die "Не передан параметр 'service'" unless defined $args{service};
    
    my $self = {
        main_router     => MainPageRouter->new(service => $args{service}),
        flights_router  => FlightsRouter->new(service => $args{service}),
        ticket_router   => TicketRouter->new(service => $args{service}),
        support_router  => SupportRouter->new(service => $args{service}),
        resource_router => ResourceRouter->new(service => $args{service}),
        location_router => LocationRouter->new(service => $args{service}),
    };
    bless $self, $class;
    return $self;
}

sub route {
    my ($self, $request) = @_;
    my $path = $request->{path} || '/';
    my $content = '';
    
    print "Router::route: запрошен путь: $path\n";
    
    # Если путь начинается с /cgi/, удаляем префикс, чтобы основной сегмент был корректным
    $path =~ s{^/cgi/}{/};
    
    # Извлекаем основной сегмент пути (до первого слеша или знака вопроса)
    my ($main) = $path =~ m{^/([^/?]+)};
    $main //= '';

    print "ПУТЬ В ОСНОВНОМ МАРШРУТИЗАТОРЕ: $path\n";
    print "ГРУППИРОВКА: $main\n";
    
    # Группировка по основному сегменту
    if ($main eq '' or $main eq 'main' or $main eq 'header' or $main eq 'menu' or $main eq 'content') {
        $content = $self->{main_router}->route($request);
    }
    elsif ($main eq 'flights') {
        $content = $self->{flights_router}->route($request);
    }
    elsif ($main eq 'tickets') {
        $content = $self->{ticket_router}->route($request);
    }
    elsif ($main eq 'support') {
        # Если поддержка, устанавливаем REQUEST_METHOD и передаём запрос в support_router
        $content = $self->{support_router}->route($request);
    }
    elsif ($main eq 'location') {
        return $self->{location_router}->route($request);
    }
    elsif ($path =~ /\.[a-zA-Z0-9]+$/) {
        # Если путь заканчивается расширением файла, удаляем начальный слеш и передаём путь в resource_router
        $path =~ s{^/}{};
        $content = $self->{resource_router}->route($path);
    }
    else {
        $content = "HTTP/1.1 404 Not Found\r\n\r\nСтраница не найдена";
    }
    
    return HttpResponse->new(content => $content);
}

1;
