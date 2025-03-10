#!/usr/bin/perl
package Handler;

use strict;
use warnings;

use lib 'server/parse';
use HttpRequest;
use HttpResponse;

sub new {
    my ($class, %args) = @_;
    my $self = {
        router => $args{router},
    };
    bless $self, $class;
    return $self;
}

sub process_request {
    my ($self, $client) = @_;

    $client->autoflush(1);
   
    # 1. Парсим HTTP-запрос
    my $request = HttpRequest->parse($client);
    
    # 2. Получаем ответ через маршрутизатор
    # print "ТЕЛО: $request->{body}\n";
    my $response = $self->{router}->route($request);

    $response->send($client);
    
    close($client);
}

1;  # Модуль должен вернуть истину