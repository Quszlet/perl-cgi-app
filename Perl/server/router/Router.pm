#!/usr/bin/perlp
package Router;

use lib 'server/HTMLGenerator/';
use lib 'server/parse/';

use HTMLGenerator;
use HttpResponse;

sub new {
    my ($class) = @_;
    my $self = {};
    bless $self, $class;
    return $self;
}

# Маршрутизатор принимает HttpRequest и возвращает HttpResponse.
# Здесь можно добавить сложную логику маршрутизации.
sub route {
    my ($self, $request) = @_;

    print "$request->{path}";

    my $path = $request->{path} || '/';
    my $content;

    if ($path eq '/') {
        $content = HTMLGenerator::generate_main_page();
    }
    elsif ($path eq '/order') {
        $content = HTMLGenerator::generate_order_page();
    }

    return HttpResponse->new(content => $content);
}

1;  # Модуль должен вернуть истину