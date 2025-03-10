#!/usr/bin/perl
package ResourceRouter;

use strict;
use warnings;
use File::Spec::Functions qw(catfile);

use lib 'server/parse/';

use HttpResponse;

# Конструктор принимает композитный объект сервисов в параметре 'service'
sub new {
    my ($class, %args) = @_;
    die "Не передан параметр 'service'" unless defined $args{service};
    my $self = {
        service => $args{service},
    };
    bless $self, $class;
    return $self;
}

sub route {
    my ($self, $path) = @_;
    my $content = '';

    # Если путь содержит расширение изображения (jpg, jpeg, png, gif)
    if ($path =~ /\.(jpg|jpeg|png|gif)$/i) {
        if (exists $self->{service}->{resource_service}) {
   
            $content = $self->{service}->{resource_service}->serve_resource($path);
        }
        else {
            $content = "HTTP/1.1 500 Internal Server Error\r\n\r\nРесурсный сервис не передан";
        }
    }
    else {
        $content = "HTTP/1.1 404 Not Found\r\n\r\nРесурс не найден";
    }
    
    return  $content;
}

1;
