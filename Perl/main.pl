#!/usr/bin/perl
package main;
use lib 'server/';
use Server;

my $server = Server->new(port => 8080);

$server->start();