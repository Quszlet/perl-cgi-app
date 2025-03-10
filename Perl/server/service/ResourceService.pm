#!/usr/bin/perl
package ResourceService;

use strict;
use warnings;
use File::Spec::Functions qw(catfile);

sub new {
    my ($class, %args) = @_;
    my $self = {
        # Базовая директория, где хранятся ресурсы (например, изображения)
        base_path => $args{base_path} || 'server/resource',
    };
    bless $self, $class;
    return $self;
}

# Метод serve_resource принимает относительный путь к ресурсу, например "airline_logo.jpg"
sub serve_resource {
    my ($self, $resource_path) = @_;
    
    # Формируем полный путь к файлу, объединяя базовый путь и относительный путь
    my $file = catfile($self->{base_path}, $resource_path);
    print "\n$file\n";  # Для отладки
    
    # Если файл не существует, возвращаем сообщение об ошибке
    unless (-e $file) {
        return "HTTP/1.1 404 Not Found\r\n\r\nResource not found: $resource_path";
    }
    
    # Открываем файл в бинарном режиме
    open my $fh, '<', $file or return "HTTP/1.1 500 Internal Server Error\r\n\r\nError opening file: $resource_path";
    binmode($fh);
    local $/;  # Считываем весь файл целиком
    my $data = <$fh>;
    close $fh;
    
    # Определяем тип контента по расширению файла
    my ($ext) = $resource_path =~ /\.([^.]+)$/;
    my $content_type = "application/octet-stream";
    if (defined $ext) {
        $ext = lc($ext);
        if ($ext eq 'png') {
            $content_type = "image/png";
        }
        elsif ($ext eq 'jpg' or $ext eq 'jpeg') {
            $content_type = "image/jpeg";
        }
        elsif ($ext eq 'gif') {
            $content_type = "image/gif";
        }
    }
    
    # # Формируем HTTP-заголовок с указанием Content-Type и Content-Length
    # my $header = "HTTP/1.1 200 OK\r\n" .
    #              "Content-Type: $content_type\r\n" .
    #              "Content-Length: " . length($data) . "\r\n\r\n";
    
    return  $data;
}

1;
