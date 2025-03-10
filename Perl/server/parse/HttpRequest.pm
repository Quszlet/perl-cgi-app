#!/usr/bin/perl
package HttpRequest;

use IO::Select;
use Data::Dumper;
    
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

use URI::Escape qw(uri_unescape);
use Encode qw(decode_utf8);

sub parse_multipart_body {
    my ($body) = @_;
    my %fields;
    
    # Вывод исходного тела для отладки
    warn "Исходное тело запроса:\n$body\n";
    
    
    # Разбиваем тело запроса по boundary
    my @parts = split /------/, $body;
    shift @parts;


    print "ВЫВОД МАССИВА SPLIT\n";
    # print Dumper(\@parts);
    foreach my $str (@parts)  
    { 
        # print "!!!!!!!!\n$str\n!!!!!!!!!!!\n";
        my $key;
        if ($str =~  /"([^"]+)"/) {
            $key = $1;
        }

        my $value;
       if ($str =~ /\n\n\s*(\S.*?)\s*\n/) {
            $value = $1;
            print "Получено: $value\n";
        }
       
    #    my $last10 = substr($str, -50);
    #    print "10 сим: $last10";
        print "$key = $value\n"; 


    } 
  
   
    return \%fields;
}

    
sub parse {
    my ($class, $client) = @_;

    # Чтение стартовой строки (например, "GET / HTTP/1.1")
    # my $request_line = <$client>;
    my $buf;
    sysread($client, $buf, 3084);
    print "BUF: $buf\n";
    my @lines = split /\r?\n/, $buf;

    # Первая строка: метод, путь и протокол
    my $request_line = shift @lines; 
    my ($method, $path, $protocol) = split ' ', $request_line;

    # Затем читаем заголовки: до тех пор, пока не встретится пустая строка
    my %headers;
    while (@lines) {
        my $line = shift @lines;
        last if $line eq '';  # пустая строка - конец заголовков
        if ($line =~ /^([^:]+):\s*(.*)$/) {
            $headers{$1} = $2;
        }
    }

    # Оставшиеся строки образуют тело запроса. Можно их объединить:
    # my $body = join "\n", @lines;

    # print "ТЕЛО В HTTPREQUESST: $body\n";

    $body = parse_multipart_body($buf);

    # # Для отладки можно вывести все значения:
    # print STDERR "Method: $method\n";
    # print STDERR "Path: $path\n";
    # print STDERR "Protocol: $protocol\n";
    # print STDERR "Headers:\n";
    # foreach my $h (keys %headers) {
    #     print STDERR "  $h: $headers{$h}\n";
    # }
    # print STDERR "Body:\n$body\n";
    
    
    # read($client, $body, $length);

    # print "ТЕЛО: $request->{body}\n";
    
    return $class->new(
        method  => $method,
        path    => $path,
        headers => \%headers,
        body    => $body,
    );
}

1;  # Модуль должен вернуть истину