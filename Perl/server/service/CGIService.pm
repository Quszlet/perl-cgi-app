#!/usr/bin/perl
package CGIService;

use strict;
use warnings;
use CGI;
use File::Spec;
use IPC::Open2;

# Конструктор (при необходимости можно добавить параметры)
sub new {
    my ($class, %args) = @_;
    my $self = {
        base_path => $args{base_path} || '.',
    };
    bless $self, $class;
    return $self;
}

sub shell_quote {
    my ($str) = @_;
    $str =~ s/'/'\\''/g;
    return "'$str'";
}

sub serve_flights {
    my ($self, $params) = @_;
    
    my $cgi_script = File::Spec->catfile($self->{base_path}, 'flights.cgi');
    
    if (-e $cgi_script) {
        my $output = '';
        my $query_string = '';
        if ($params && %$params) {
            $query_string = join '&', map { "$_=" . ($params->{$_} || '') } keys %$params;
        }

        $ENV{QUERY_STRING} = $query_string;
        $ENV{REQUEST_METHOD} = "GET";  # устанавливаем метод запроса
        
        # Выполняем CGI‑скрипт и захватываем его вывод
        open(my $fh, "-|", $cgi_script)
            or return "HTTP/1.1 500 Internal Server Error\r\n\r\nОшибка при выполнении CGI-скрипта: $cgi_script";
        {
            local $/;
            $output = <$fh>;
        }
        close($fh);
        return $output;
    }
    else {
        return "HTTP/1.1 404 Not Found\r\n\r\nCGI-скрипт не найден: $cgi_script";
    }
}


# Метод для генерации страницы оформления билета
sub serve_ticket {
    my ($self, $request) = @_;
    
    $ENV{'REQUEST_METHOD'} = $request->{method} || 'GET';
    
    my ($script, $query) = split /\?/, ($request->{path} || ''), 2;
    $ENV{'QUERY_STRING'} = defined $query ? $query : '';
    
    my $cgi_script = File::Spec->catfile($self->{base_path}, 'tickets.cgi');
    
    if (-e $cgi_script) {
        my $output = '';
       
        open(my $fh, "-|", $cgi_script)
            or return "HTTP/1.1 500 Internal Server Error\r\n\r\nОшибка при выполнении CGI-скрипта: $cgi_script";
        {
            local $/;
            $output = <$fh>;
        }
        close($fh);
        return $output;
    }
    else {
        return "HTTP/1.1 404 Not Found\r\n\r\nCGI-скрипт не найден: $cgi_script";
    }
}

use IPC::Open2;

sub serve_support_submit {
    my ($self, $request) = @_;
    
    # Устанавливаем метод запроса на POST
    $ENV{'REQUEST_METHOD'} = 'POST';
    
    # Получаем данные POST из тела запроса
    my $post_data = $request->{body} // '';
    print "POST_DATA: $post_data\n";
    
    # Устанавливаем необходимые переменные окружения для POST
    $ENV{'CONTENT_LENGTH'} = length($post_data);
    $ENV{'CONTENT_TYPE'} = $request->{headers}{'Content-Type'} // 'application/x-www-form-urlencoded';
    
    # Формируем путь к CGI‑скрипту для поддержки
    my $cgi_script = File::Spec->catfile($self->{base_path}, 'support_submit.cgi');
    print "СФОРМИРОВАН ПУТЬ: $cgi_script\n";
    
    unless (-e $cgi_script) {
        return "HTTP/1.1 404 Not Found\r\n\r\nCGI-скрипт не найден: $cgi_script";
    }
    
    my $output = '';
    # Открываем канал: $fh_out для чтения результата, $fh_in для передачи POST-данных
    my $pid = open2(my $fh_out, my $fh_in, $cgi_script)
        or return "HTTP/1.1 500 Internal Server Error\r\n\r\nОшибка при выполнении CGI-скрипта: $cgi_script";
    
    # Передаём POST-данные в STDIN CGI-скрипта
    print $fh_in $post_data;
    close($fh_in);
    
    {
        local $/;
        $output = <$fh_out>;
    }
    close($fh_out);
    waitpid($pid, 0);
    
    return $output;
}


1;
