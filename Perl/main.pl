#!/usr/bin/perl
package main;
use lib 'server/';
use lib 'server/handler/';
use lib 'server/router';
use lib 'server/repository';
use lib 'server/service';

use Sqlite;
use Repository;
use Handler;
use Server;
use Router;
use Service;

my $db = Sqlite->connect();

my $repository = Repository->new(dbh => $db);

my $service = Service->new(repository => $repository);

my $router = Router->new(service => $service);

my $handler = Handler->new(router => $router);

my $server = Server->new(
    port => 8080,
    handler => $handler,
 );

$server->start();