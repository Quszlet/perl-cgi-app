#!/usr/bin/perl
package TicketsRepository;

use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $self = {
        db => $args{dbh},  # DBI-хендл
    };
    bless $self, $class;
    return $self;
}

sub save_ticket {

}

1;