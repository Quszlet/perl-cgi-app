#!/usr/bin/perl
package HTMLService;

use strict;
use warnings;
use File::Spec;

sub new {
    my ($class, %args) = @_;
    my $self = {
        base_path => $args{base_path} || 'server/html/',
    };
    bless $self, $class;
    return $self;
}

# Отдает главный фрейм (например, mainpage.html)
sub serve_main {
    my ($self) = @_;
    my $file = File::Spec->catfile($self->{base_path}, 'mainpage/mainpage.html');
    return $self->_read_file($file);
}

# Отдает фрейм заголовка (header.html)
sub serve_header {
    my ($self) = @_;
    my $file = File::Spec->catfile($self->{base_path}, 'mainpage/header.html');
    return $self->_read_file($file);
}

# Отдает фрейм меню (menu.html)
sub serve_menu {
    my ($self) = @_;
    my $file = File::Spec->catfile($self->{base_path}, 'mainpage/menu.html');
    return $self->_read_file($file);
}

# Отдает фрейм основного контента (content.html)
sub serve_content {
    my ($self) = @_;
    my $file = File::Spec->catfile($self->{base_path}, 'mainpage/content.html');
    return $self->_read_file($file);
}


sub serve_support {
    my ($self) = @_;
    my $file ="$self->{base_path}/support.html";
    return $self->_read_file($file);
}


# Вспомогательная функция для чтения содержимого файла (режим "slurp")
sub _read_file {
    my ($self, $file) = @_;
    if (-e $file) {
        open my $fh, '<', $file or return "HTTP/1.1 500 Internal Server Error\r\n\r\nОшибка открытия файла: $file";
        local $/;  # режим slurp – считываем весь файл целиком
        my $content = <$fh>;
        close $fh;
        return $content;
    }
    else {
        return "HTTP/1.1 404 Not Found\r\n\r\nФайл не найден: $file";
    }
}

1;
