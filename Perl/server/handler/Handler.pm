#!/usr/bin/perl
package Handler;

use strict;
use warnings;

use lib 'server/parse';
use lib 'server/router';
use HttpRequest;
use HttpResponse;
use Router;

sub new {
    my ($class, %args) = @_;
    my $self = {
        client => $args{client},
    };
    bless $self, $class;
    return $self;
}

sub process_request {
    my ($self) = @_;
    print "Handler::process_request: обработка запроса\n";
    my $client = $self->{client};
    $client->autoflush(1);
    print "Handler::process_request: приколы с клиентом\n";
    
    # 1. Парсим HTTP-запрос
    my $request = HttpRequest->parse($client);
    print "Handler::process_request: распарсился http запрос \n";
    # 2. Получаем ответ через маршрутизатор
    print "$request->{path}";
    my $router   = Router->new();
    my $response = $router->route($request);
    print "Handler::process_request: сформировали ответ \n";
    # 3. Отправляем ответ клиенту
    $response->send($client);
    print "Handler::process_request: отправили ответ клиенту \n";
    
    close($client);
}

1;  # Модуль должен вернуть истину