#!/usr/bin/perl
package Server;

use strict;
use warnings;
use IO::Socket::INET;
use Scalar::Util 'blessed';

    
sub new {
    my ($class, %args) = @_;
    my $self = {
        port => $args{port} || 8080,
        handler => $args{handler},
    };
    bless $self, $class;
    return $self;
}

sub start {
    my ($self) = @_;
    # Создаем серверный сокет
    my $server = IO::Socket::INET->new(
        LocalPort => $self->{port},
        Listen    => 10,
        Reuse     => 1,
        Proto     => 'tcp'
    ) or die "Не удалось создать сервер на порту $self->{port}: $!";
    
    print "Сервер запущен на порту $self->{port}...\n";
    
    while (my $client = $server->accept()) {
        # Для каждого клиента создаём дочерний процесс (fork)
        my $pid = fork();
        if (!defined $pid) {
            warn "Ошибка fork: $!";
            next;
        }
        if ($pid == 0) {
            # Дочерний процесс обрабатывает запрос
            $server->close();
            $self->{handler}->process_request($client);
            exit(0);
        }
        # Родительский процесс закрывает клиентский сокет и продолжает принимать новые соединения
        close($client);
    }
}

1;  # Модуль должен вернуть истину