#!/usr/bin/perl
package HttpResponse;

sub new {
    my ($class, %args) = @_;
    my $self = {
        status  => $args{status}  || 200,
        headers => $args{headers} || {},
        content => $args{content} || '',
    };
    bless $self, $class;
    return $self;
}

sub send {
    my ($self, $client) = @_;
    my $content = $self->{content};
    # Устанавливаем обязательные заголовки
    $self->{headers}->{'Content-Length'} = length($content);
    $self->{headers}->{'Content-Type'} ||= 'text/html; charset=UTF-8';
    
    print $client "HTTP/1.1 $self->{status} OK\r\n";
    foreach my $header (keys %{ $self->{headers} }) {
        print $client "$header: $self->{headers}->{$header}\r\n";
    }
    print $client "\r\n";
    print $client $content;
}

1;  # Модуль должен вернуть истину