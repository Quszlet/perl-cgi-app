#!/usr/bin/perl
package HttpRequest;

use IO::Select;
    
sub new {
    my ($class, %args) = @_;
    my $self = {
        method  => $args{method}  || '',
        path    => $args{path}    || '',
        headers => $args{headers} || {},
        body    => $args{body}    || '',
    };
    bless $self, $class;
    return $self;
}
    
sub parse {
    my ($class, $client) = @_;
    
    # Чтение стартовой строки (например, "GET / HTTP/1.1")
    my $request_line = <$client>;
    print "Request line: $request_line\n";
    return $class->new() unless defined $request_line;
    chomp $request_line;
    my ($method, $path, $protocol) = split(' ', $request_line);
    
    # Чтение заголовков с таймаутом
    my %headers;
    my $selector = IO::Select->new($client);
    my $timeout = 1;  # секунды
    while (1) {
        # Если данные не поступают в течение $timeout секунд, выходим
        if (!$selector->can_read($timeout)) {
            warn "Таймаут ожидания заголовков\n";
            last;
        }
        my $line = <$client>;
        last unless defined $line;  # конец потока
        chomp $line;
        last if $line eq '';
        if ($line =~ /^([^:]+):\s*(.*)$/) {
            $headers{$1} = $2;
        }
    }
    
    return $class->new(
        method  => $method,
        path    => $path,
        headers => \%headers,
    );
}
1;  # Модуль должен вернуть истину